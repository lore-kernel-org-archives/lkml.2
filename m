Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0ELCnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:43:01 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46333 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab0ELCm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:42:59 -0400
Date: Wed, 12 May 2010 11:42:58 +0900
From: Norbert Preining <preining@logic.at>
To: Alejandro Riveira =?iso-8859-15?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ipheth device not showing up
Message-ID: <20100512024258.GB14797@gamma.logic.tuwien.ac.at>
References: <20100511165159.GA9614@gamma.logic.tuwien.ac.at> <20100511205918.70c21413@varda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100511205918.70c21413@varda>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 11 Mai 2010, Alejandro Riveira Fernández wrote:
> > [46128.590402] usb 2-1: Product: iPhone
> > [46128.590407] usb 2-1: Manufacturer: Apple Inc.
> > [46128.590411] usb 2-1: SerialNumber: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
> > [46128.717504] ipheth 2-1:4.2: Apple iPhone USB Ethernet device attached
> > 
> > so it seems that there should be an ethernet device, but ifconfig -a
> > or any other way I can imagine to check does not show the new device.
> > 
> > Am I missing something?
> 
>  http://giagio.com/wiki/moin.cgi/iPhoneEthernetDriver
> 
>   The "pairing" program in the link above ? Google is your friend :)

Sorry, forgot that, pairing program is called, but does not change
anything. It is called automatically by udev, but I also tried manually.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
VANCOUVER (n.)
The technical name for one of those huge trucks with whirling brushes
on the bottom used to clean streets.
			--- Douglas Adams, The Meaning of Liff
