Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2EDJcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 05:32:13 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2910 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab2EDJcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 05:32:12 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4FA39F5C.1070501@broadcom.com>
Date: Fri, 4 May 2012 11:20:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Chris Jones" <chrisjones@spin.net.au>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Hard drive detection
References: <20120504185604.3addfd2e@ubuntu>
In-Reply-To: <20120504185604.3addfd2e@ubuntu>
X-Enigmail-Version: 1.4
X-WSS-ID: 63BD7DAB3E027353667-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 10:56 AM, Chris Jones wrote:
> What section of the kernel detects internal hard drives upon boot?

A bit of a weird question, but maybe I do not understand where it is
coming from. Some context might help.

The hard drives are likely connected to a harddisk controller of some
sort and that controller is somehow hooked up in your system. Your
kernel needs a driver for the controller. It is 'convenient' to have
that driver built in your kernel for the hard drive containing the root
file system.

Gr. AvS

