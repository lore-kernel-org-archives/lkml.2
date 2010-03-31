Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab0CaATM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:19:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756641Ab0CaATH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 20:19:07 -0400
Date: Tue, 30 Mar 2010 17:13:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, stable-review@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [087/116] PCI quirk: RS780/RS880: work around missing MSI
 initialization
In-Reply-To: <20100330225656.136257690@linux.site>
Message-ID: <alpine.LFD.2.00.1003301711330.3707@i5.linux-foundation.org>
References: <20100330225656.136257690@linux.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 30 Mar 2010, Greg KH wrote:
>
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Clemens Ladisch <clemens@ladisch.de>
> 
> commit a5ee4eb75413c145334c30e43f1af9875dad6fd7 upstream.

NAK. 

Rafael reports this causes a regression. I don't think we know why, but 
more importantly, that definitely means this is not stable material.

		Linus
