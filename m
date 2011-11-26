Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1KZSJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 13:09:40 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:54473 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183Ab1KZSJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 13:09:38 -0500
Message-ID: <4ED12B50.9090206@metafoo.de>
Date: Sat, 26 Nov 2011 19:09:20 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-iio@vger.kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org,
        federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 0/7] Introducing ZIO, a new I/O framework
References: <cover.1322328073.git.rubini@gnudd.com>
In-Reply-To: <cover.1322328073.git.rubini@gnudd.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2011 06:30 PM, Alessandro Rubini wrote:
> This RFC patch-set introduces the ZIO framework for input/output,
> which will be used in the new series of drivers by the BE-CO-HT
> group at CERN.
> 
> The use-case it is meant to cover is very fast I/O with
> hardware-provided timestamps.  The first production driver we will
> support is a 100Ms/s 4-channel 14-bit ADC (developed on ohwr: see
> http://www.ohwr.org/projects/fmc-adc-100m14b4cha ).  We need similar
> bandwidth on output.
> 
> The synchronization engine of that FMC card and other ones is going to
> be White Rabbit (http://www.ohwr.org/projects/white-rabbit).
> 
> Currently, the patch-set includes one example driver (zio-zero)
> that behaves like /dev/zero and /dev/urandom. Other drivers will
> come soon, both demo and real hardware.
> 
> Slides for a tutorial on the design ideas are online here:
> http://www.ohwr.org/attachments/881/zio-111123.pdf
> 
> A list of pending issues and development plans is online at:
> http://www.ohwr.org/projects/zio/wiki/Todo

You've Cc'ed the IIO mailinglist, so you know about the IIO framework. Could
you explain why you need a new framework and your devices can't be supported by
the IIO framework? After a first quick glance ZIO looks to me like a subset of IIO.

- Lars
