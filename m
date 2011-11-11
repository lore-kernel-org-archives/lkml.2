Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab1KKMEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 07:04:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35834 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1KKMEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 07:04:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
Subject: Re: [BUG] NULL deref in swapin_readahead
Date: Fri, 11 Nov 2011 13:07:02 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: len.brown@intel.com, pavel@ucw.cz, linux-kernel@vger.kernel.org
References: <4EBD0767.8040901@cwi.nl>
In-Reply-To: <4EBD0767.8040901@cwi.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201111111307.02203.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 11, 2011, Wouter M. Koolen wrote:
> Hi suspend gurus,
> 
> I got the attached NULL deref while closing and immediately reopening my 
> laptop lid. The laptop is configured to suspend to RAM.
> 
> Google yields nothing similar for "unable to handle kernel NULL pointer 
> dereference" "swapin_readahead" "radix_tree_lookup", so I guess this is 
> an as-yet unknown problem. If not, please excuse the noise.
> 
> Kernel (vanilla 3.1.0) config attached. The laptop is a MacBook4,1.
> 
> The machine goes on to print a series of soft lockup reports, but I 
> assumed they are PTSD and omited them.

Well, the trace doesn't indicate how the problem is related to the
suspend/resume code paths.

Is this a regression for you?

Thanks,
Rafael
