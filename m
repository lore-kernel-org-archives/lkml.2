Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab1BWUYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:24:22 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4813 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556Ab1BWUYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:24:20 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
To: "Greg KH" <gregkh@suse.de>
cc: "Ben Hutchings" <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "Roland Vossen" <rvossen@broadcom.com>,
        "Brett Rudley" <brudley@broadcom.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Stable-review] [28/70] staging: brcm80211: bugfix for
 softmac crash on multi cpu configurations
References: <20110222221839.853712243@clark.kroah.org>
 <1298427787.2211.498.camel@localhost> <op.vrciafbg3ri7v4@arend-laptop>
 <20110223180627.GB30106@suse.de>
Date: Wed, 23 Feb 2011 21:24:01 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vrdhl9qk3ri7v4@arend-laptop>
In-Reply-To: <20110223180627.GB30106@suse.de>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 617BB2E13BS2602623-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 Feb 2011 19:06:27 +0100, Greg KH <gregkh@suse.de> wrote:

> On Wed, Feb 23, 2011 at 08:40:53AM +0100, Arend van Spriel wrote:
>> On Wed, 23 Feb 2011 03:23:07 +0100, Ben Hutchings
>> <ben@decadent.org.uk> wrote:
>>
>> >On Tue, 2011-02-22 at 14:17 -0800, Greg KH wrote:
>> >>2.6.37-stable review patch.  If anyone has any objections,
>
> So, what should I do here?  Drop the referenced patch from the
> .37-stable queue, or do you have the text for the changelog that I
> should use here instead?
>
> confused,
>
Hi Greg,

Dito here. I submitted a patch for the stable kernel and Roland did one  
(if I am correct). I have no clue how his commit message came with my  
patch or vice versa.

>
> greg k-h
>

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

