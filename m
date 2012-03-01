Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2CAAU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:20:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab2CAAU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:20:27 -0500
Date: Wed, 29 Feb 2012 16:20:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Muthu Kumar <muthu.lkml@gmail.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, martin.petersen@oracle.com
Subject: Re: [PATCH] Fix setting bio flags in drivers (sd_dif/floppy).
Message-Id: <20120229162025.411ef202.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFwnF9Vu3JU6wuGMSeSiQqXrH+hqsZ2Ux79+2eH3A+_5MA@mail.gmail.com>
References: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com>
	<CA+55aFwnF9Vu3JU6wuGMSeSiQqXrH+hqsZ2Ux79+2eH3A+_5MA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 16:08:15 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Feb 29, 2012 at 3:22 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
> > Fix setting bio flags in drivers (sd_dif/floppy).
> 
> A quick grep seems to agree that these are the only obvious ones.
> 
> Jens? Will you send this to me, or should I take it directly?

I'll send at you tomorrowish.  Or you can take it directly, after fixing
the wordwrapping ;)

I don't know if a -stable backport is warranted...

> And when did Andrew change his name? Nobody tells me these things.

oh gawd no.  Somehow google managed to replace my name with my son's in
various people's address books.  Now it's gone and done it with
akpm@linux-foundation.org as well as akpm@google.com.  I'm in a losing
fight trying to prevent those two identities from getting intermingled,
absorbed and generally borgified.  And how did google know that we're
related?  I can only think that it snarfed that connection from
facebook.
