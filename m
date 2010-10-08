Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0JHHQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:16:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43691 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab0JHHQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SS01BU2lfR6JdyWZfTDFyYHmeyHqs2Pgs29Pa4lxwpWrioyVaBXPKkzAU9o9SYvGPq
         eDEHn7jaR/DSS2M862SAfnBpCFLZt+AEfglqnyoilx6+2Npg/jy56SqgEsOtpzA0Mvxb
         zoGpsDvmGWJN+sPdZ6ORpeM1LghXGBJ3f/SHU=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Hc2eWzOQ_xKBYsqfwkkiKGU0v42jUhLQ8K7dU@mail.gmail.com>
References: <AANLkTi=Hc2eWzOQ_xKBYsqfwkkiKGU0v42jUhLQ8K7dU@mail.gmail.com>
Date: Fri, 8 Oct 2010 00:16:35 -0700
Message-ID: <AANLkTinynZj9bYFAyfRTF2uopmLe6Ls4YGdZPqCAJTpR@mail.gmail.com>
Subject: Re: [PATCH 00/33] Staging: Fixed <module-objs> to <module>-y
From: matt mooney <mfmooney@gmail.com>
To: T Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, sam@ravnborg.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 6:35 PM, T Dent <tdent48227@gmail.com> wrote:
> I patch against the next-20101006 tree.
>
> The patch series replace use of <module>-objs with <module>-y in the
> staging directory.

Commit messages are written in the present tense. You happen to be
using two different tenses within the commit message, which is truly
odd.  And why did you not split apart those atrocious statements with
the infinite column width?

This patch series adds little benefit.  As Sam has suggested, a more
general cleanup would be a better goal, and staging is an area that
needs extra attention some of which has already been pointed out in
other emails.

-mfm

-- 
GPG-Key: 9AFE00EA
