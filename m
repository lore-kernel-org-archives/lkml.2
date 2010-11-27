Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0K0NjG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 08:39:06 -0500
Received: from nm15.bullet.mail.ukl.yahoo.com ([217.146.183.189]:38963 "HELO
	nm15.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752217Ab0K0NjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 08:39:01 -0500
X-Yahoo-Newman-Id: 179286.74655.bm@omp1027.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
  b=ZcIh2R+xmW+sP11Cr4eu5+YAmqRKSg3eDqNYQRigVhVWnaMnVD2rrb8P2hoMhxxobsWHjCF3xN9hg3Mxu3e1du7652QCLUR/nij1jT0O9fkoNIuEOxSFtLr/B3ZvPBhK7PWAHot1n/4CcolSbfx3lAfVWzKZAujfpCnJ8t3BFfM=  ;
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-YMail-OSG: 68YdQuIVM1kG370z25I8g8lX8jrCVqwn.nQ33sd_QQKE0If
 Z8ZbgXgrRfiX9_Sd1TIe7xVIJWyRpcPsCFzbMUEdNbI84pCZmDxZkhrR6eKJ
 l5_qRZPoWQxH6jDfFn_rqeDxNzTcFPdo8WaIuWhKLws_Nnrh_WK4HMscu.Vy
 NZELci.fyXDM0V4hIXTQydGY8ZgwSWwvfAUcqa8wmGvInRtfx3xrqRDVH8vu
 DR8lczCpvi4EnEKvAFs_j5n6dli693rSu0mzKWTKKCQpBCT5P.AQNlvU4qQH
 mCYiqgorJg7keVUQwsbaDlIsBmMDxyve2hasDfrULAZlwStU-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4CF109D0.80104@yahoo.fr>
Date: Sat, 27 Nov 2010 14:38:24 +0100
From: Lionel Debroux <lionel_debroux@yahoo.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100131 Thunderbird/3.0.1
MIME-Version: 1.0
To: Spelic <spelic@shiftmail.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Can't find fourth number version tags in GIT kernel
References: <4CF1028A.6010401@shiftmail.org>
In-Reply-To: <4CF1028A.6010401@shiftmail.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 27.11.2010 14:07, Spelic wrote:
> Hello LKML
> I'm trying to use GIT to stay up-to-date with the kernel sources,
> but in
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> and even
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.36.y.git
> 
> I can't find versions with four numbers, e.g. I do find tag:
> 
> v2.6.35
> (and also the release candidates for 2.6.35)
> 
> but I can't find tags:
> 
> v2.6.35.1
> v2.6.35.2
> ...
> v2.6.35.9
> 
> Apparently tag v2.6.35 really brings me to v2.6.35.0 and not to
> v2.6.35.9 so it's a problem... I usually want to get the highest
> number in the fourth number, not the lowest.
> Like this I don't know how to get the bugfixes...?
> 
> What am I missing?
> 
> Thank you
> PS: can you please reply to me also, as I am not subscribed to LKML.
> Thanks
For 2.6.35 tags, you need to use the 2.6.35.y repository:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git

More generally, or 2.6.x.y tags with x >= 11, use the 2.6.x.y tree.

Also noteworthy is the combined tree for 2.6.x.y updates:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6-stable.git


Hope that this helps,
Lionel.
