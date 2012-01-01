Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab2AAHRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 02:17:20 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59991 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2AAHRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 02:17:16 -0500
MIME-Version: 1.0
In-Reply-To: <CADHUQJ4NHSGs-=g-rfzoAWRLi8SmNPtfeeC4XPuAa2bO91oRug@mail.gmail.com>
References: <1325062439-1325-1-git-send-email-roland@kernel.org>
 <20111230093638.GC26473@logfs.org> <CADHUQJ4NHSGs-=g-rfzoAWRLi8SmNPtfeeC4XPuAa2bO91oRug@mail.gmail.com>
From: Roland Dreier <roland@kernel.org>
Date: Sat, 31 Dec 2011 23:16:54 -0800
X-Google-Sender-Auth: oR2lknAdhYSTGIfwTkbDRbo_qco
Message-ID: <CAG4TOxMZ00R9DBeusCnEGvVyxhBJS8rrBdeAgY=eW5CjGOR0dg@mail.gmail.com>
Subject: Re: [PATCH] btree: Export btree_get_prev() so modules can use btree_for_each
To: Steve Hodgson <steve@purestorage.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 31, 2011 at 7:22 PM, Steve Hodgson <steve@purestorage.com> wrote:
> Signed-off-by: Steve Hodgson
>
> Or you would prefer the patch is resent with my Sign-off in the commit
> message?

A properly formed S-o-b line has the email address too... but in any case I
don't think it should be necessary in this case.  First of all the patch is a
pretty trivial one-liner... but in any case as I understand things I should be
able to submit patches from our company's internal tree and both preserve
authorship (ie "From: Steve") but also be the first person sending it out.

Looking at "Developer's Certificate of Origin 1.1" in SubmittingPatches, I
guess I am certifying (b), ie

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

(Since I actually did write the changelog for the patch)

 - R.
