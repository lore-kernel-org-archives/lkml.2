Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab2K0Xa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:30:56 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54001 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab2K0Xax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:30:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121128102800.97a1a4d895f0bfaf72b80272@canb.auug.org.au>
References: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au> <20121128102800.97a1a4d895f0bfaf72b80272@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Nov 2012 15:30:31 -0800
X-Google-Sender-Auth: AGLVgG9tY4PNV05S3R8mKwx2vDo
Message-ID: <CA+55aFxxq9a8ZQfcMC1=cKO90zu6hqvfJipt1t0tJy1ypYw30w@mail.gmail.com>
Subject: Re: linux-next: unusual update of the security tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 3:28 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> If that is what happened, it may be worth always using the --no-ff flag
> to git merge/pull to make sure that the top commit on your tree always
> has you as the committer (and maybe SOB).
>
> Linus, does that make sense in general for maintainers?

No. That just hides the real problem - back-merges of random points in history.

Don't do them, people. EVER.

              Linus
