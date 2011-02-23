Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1BWHlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:41:12 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3718 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab1BWHlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:41:10 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
To: "Greg KH" <gregkh@suse.de>, "Ben Hutchings" <ben@decadent.org.uk>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
 <1298427787.2211.498.camel@localhost>
Date: Wed, 23 Feb 2011 08:40:53 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vrciafbg3ri7v4@arend-laptop>
In-Reply-To: <1298427787.2211.498.camel@localhost>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 617A65073BS2259015-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 03:23:07 +0100, Ben Hutchings <ben@decadent.org.uk>  
wrote:

> On Tue, 2011-02-22 at 14:17 -0800, Greg KH wrote:
>> 2.6.37-stable review patch.  If anyone has any objections, please let  
>> us know.
>>
>> ------------------
>
> Why is this so different?
>

Hi Ben,

I think you are right. The diff below actually is from another commit  
which I posted for stable review titled:

staging: brcm80211: remove assert to avoid panic since 2.6.37 kernel

Gr. AvS

>
> Ben.
>
> [...]
>>  drivers/staging/brcm80211/sys/wlc_mac80211.c |    1 -
>>  1 file changed, 1 deletion(-)
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

