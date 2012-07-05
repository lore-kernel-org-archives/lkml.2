Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2GETzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:55:54 -0400
Received: from mail.snarked.org ([67.43.172.250]:60298 "EHLO mail.snarked.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab2GETzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:55:32 -0400
X-Envelope-From: <newsserv> (mail.snarked.org)
To: linux-kernel@vger.kernel.org
From: "D. Stussy" <spam+newsgroups@bde-arc.ampr.org>
Newsgroups: linux.kernel
Subject: Re: Intel e1000 ethernet device, change in kernel v3.4, and jumbo  frames setting DENIED.
Date: Thu, 5 Jul 2012 12:55:31 -0700
Message-ID: <jt4rfk$enl$1@snarked.org>
References: <jjE3E-5PM-29@gated-at.bofh.it> <jjGoO-7l0-19@gated-at.bofh.it>
Reply-To: "D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-No-Archive: Yes
X-MimeOLE: Produced By Microsoft MimeOLE V15.4.3555.308
In-Reply-To: <jjGoO-7l0-19@gated-at.bofh.it>
X-Newsreader: Microsoft Windows Live Mail 15.4.3555.308
Importance: Normal
X-Priority: 3
X-MSMail-Priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Henrique de Moraes Holschuh"  wrote in message 
news:jjGoO-7l0-19@gated-at.bofh.it...

On Wed, 04 Jul 2012, D. Stussy wrote:
> There has been some changes to the driver such that things like
> checksum verification is offloaded from the CPU.  However, this
> blocks the ability to set a jumbo frame.  The kernel does record an
> error indicating that checksum offloading need be disabled fro jumbo
> frame MTU sizes to be used.  My e1000 interfaces use the 82574L
> chipset.
>
> 1)  Was this an intentional change?

Yes, but I understand Intel is trying to come up with a way not to need it.

> 2)  How do I disable that function so I can set jumbo frames with
> "ifconfig" or "ip"?  I simply don't know what setting I need to
> pass.

ethtool can do it.  Check its manpage, it can manipulate the various NIC
offload engines, as well as other parameters such as dma ring buffer size,
etc.
=====================
I'll look into it.  Thanks. 

