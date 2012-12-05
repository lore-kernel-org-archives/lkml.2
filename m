Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2LEPqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:46:01 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41522 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2LEPp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:45:59 -0500
MIME-Version: 1.0
In-Reply-To: <201212051148.28039.Martin@lichtvoll.de>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121126025520.GC22858@thunk.org> <20121126091202.GO32450@dastard> <201212051148.28039.Martin@lichtvoll.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Dec 2012 07:45:39 -0800
X-Google-Sender-Auth: pMr26-n03-LYlXJAP-q-A-g7cTs
Message-ID: <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 2:48 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>
> Linus, while I am interested in an answer I think that Dave and Christoph
> as Linux filesystem developers actually deserve one (instead of silently
> being ignored which is also a decision in this matter).
>
> I did not see an answer in linux-2.6 commit log as of today so far.

Christ guys. This whole thread is retarded.

The *ONLY* reason people seem to have for reverting that is a "ooh, my
feelings are hurt by how this was done, and now I'm a pissy bitch and
I want to get this reverted".

Stop the f*cking around already.

If you want something reverted, you show me the *technical* reason for
it. Not the "ooh, I'm so annoyed by how this was done" reason for it.

And if your little feelings got hurt, get your mommy to tuck you in,
don't email me about it. Because I'm not exactly known for my deep
emotional understanding and supportive personality, am I?

               Linus
