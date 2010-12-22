Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0LVKig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:38:36 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53539 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0LVKie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=VFMZ44cFNMV82MAMjnkNacCMhQXyJr11HJ/YZp0tXz5aXQ9S+1Fz/49ZRVKde1OSQe
         ENpq0TltmJEFd2ROZF2J9SxEFgM4Bf5SpWmPqyqvTxxANzgaf3OVEMeqPFEskgBR4tPr
         hPeGj4WpRPwEPDOtcWKbbIcxax6fazmwvhb9g=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101222095332.GA3430@amd>
References: <20101222095332.GA3430@amd>
Date: Wed, 22 Dec 2010 11:38:33 +0100
Message-ID: <AANLkTik+LyC1BpJq4LP=7bn-4ZSwQza95SjoS6Tc=NbD@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 10:53 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> Git tree is here:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
>
> Branch is:
>
>    vfs-scale-working
>

Hmm, looks like the new commits were not committed to your remote GIT branch.
Just as a hint the EU mirror seems to work faster for GIT repos
(s/git.kernel.org/git.eu.kernel.org).

- Sedat -

P.S.:

$ git pull git://git.eu.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
vfs-scale-working:vfs-scale-working
Already up-to-date.

$ git log -1 | cat
commit 695394855fba70ce7e833e4742792e9a738af6b0
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Tue Dec 21 18:13:04 2010 +1100

    Add linux-next specific files for 20101221

    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
