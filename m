Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2LEQSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:18:49 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34307 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2LEQSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:18:45 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
Date: Wed, 5 Dec 2012 17:18:43 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc7-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com> (sfid-20121205_171430_627500_5E3A2128)
In-Reply-To: <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212051718.44017.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. Dezember 2012 schrieb Linus Torvalds:
> On Wed, Dec 5, 2012 at 2:48 AM, Martin Steigerwald <Martin@lichtvoll.de> 
wrote:
> > Linus, while I am interested in an answer I think that Dave and
> > Christoph as Linux filesystem developers actually deserve one
> > (instead of silently being ignored which is also a decision in this
> > matter).
> > 
> > I did not see an answer in linux-2.6 commit log as of today so far.
> 
> Christ guys. This whole thread is retarded.
> 
> The *ONLY* reason people seem to have for reverting that is a "ooh, my
> feelings are hurt by how this was done, and now I'm a pissy bitch and
> I want to get this reverted".
> 
> Stop the f*cking around already.
> 
> If you want something reverted, you show me the *technical* reason for
> it. Not the "ooh, I'm so annoyed by how this was done" reason for it.
> 
> And if your little feelings got hurt, get your mommy to tuck you in,
> don't email me about it. Because I'm not exactly known for my deep
> emotional understanding and supportive personality, am I?

Did you actually *read* the thread, Linus?

Dave provided technical reasons.

First in the patch description and then in:

https://lkml.org/lkml/2012/11/26/700

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
