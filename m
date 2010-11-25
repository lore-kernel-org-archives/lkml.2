Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0KYKvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:51:53 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:5107 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752393Ab0KYKvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:51:51 -0500
Message-ID: <4CEE3F77.4020206@draigBrady.com>
Date: Thu, 25 Nov 2010 10:50:31 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Subject: Re: VFS support for fast copy on deduplicating FSes
References: <AANLkTinz17SePZCCixBCA_WoW3rFWAsB7mRghL9uN17h@mail.gmail.com> <20101125103258.GA16562@mother.pipebreaker.pl>
In-Reply-To: <20101125103258.GA16562@mother.pipebreaker.pl>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/11/10 10:32, Tomasz Torcz wrote:
> On Thu, Nov 25, 2010 at 04:19:17AM -0600, David Nicol wrote:
>> unresearched question/suggestion:
>>
>> Is there general support for a "fast copy" ioctl in the VFS layer,
>> which would be hooked by file systems that support COW or other forms
>> of deduplication and can provide copy semantics by manipulating
>> metadata only?
>>
> 
>   Yes, see reflink(2) syscall (http://lwn.net/Articles/331576/).
> 

Yep and this: http://lwn.net/Articles/335380/
Note that cp --reflink has been supported for a while,
but it's BTRFS specific at the moment.
We'll need to change to the more generic interface.

cheers,
Pádraig.
