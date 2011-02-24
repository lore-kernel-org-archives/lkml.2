Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1BXUsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:48:09 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:1196 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab1BXUsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:48:06 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
To: "Roland Vossen" <rvossen@broadcom.com>, "Greg KH" <gregkh@suse.de>
cc: "Ben Hutchings" <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "Brett Rudley" <brudley@broadcom.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Stable-review] [28/70] staging: brcm80211: bugfix for
 softmac crash on multi cpu configurations
References: <20110222221839.853712243@clark.kroah.org>
 <1298427787.2211.498.camel@localhost> <op.vrciafbg3ri7v4@arend-laptop>
 <20110223180627.GB30106@suse.de> <op.vrdhl9qk3ri7v4@arend-laptop>
 <4D6658D7.1010501@broadcom.com> <20110224182133.GA18081@suse.de>
Date: Thu, 24 Feb 2011 21:47:49 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vrfddzvf3ri7v4@arend-laptop>
In-Reply-To: <20110224182133.GA18081@suse.de>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 61781BFD5OK12005578-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 19:21:33 +0100, Greg KH <gregkh@suse.de> wrote:

>
> Ok, I'm going to drop this patch now.
>
> Can someone create the needed patches for the .37-stable tree that
> should be included and send them to me and cc: stable@kernel.org so I
> can queue them up for the next .37-stable release after this?
>

Hi Greg,

I sent both patches to you.

>
> thanks,
>
> greg k-h
>

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

