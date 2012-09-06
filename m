Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2IFDcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:32:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58716 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2IFDcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:32:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120903191801.GA23227@pobox.suse.cz>
References: <20120903191801.GA23227@pobox.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Sep 2012 20:32:00 -0700
X-Google-Sender-Auth: M2Xp9p8UQnmKX67ReDVN_957toE
Message-ID: <CA+55aFzBsKBmVMRiJ8yuML_QVQbfa2ZqHU_fh3_wS3YhLTv9fw@mail.gmail.com>
Subject: Re: [GIT] kbuild rc fixes for v3.6
To: Michal Marek <mmarek@suse.cz>
Cc: mark.asselstine@windriver.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 12:18 PM, Michal Marek <mmarek@suse.cz> wrote:
>
> The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:
>
>   Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)
>
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git ..BRANCH.NOT.VERIFIED..

There's something wrong with that repo

 "fatal: Could not read from remote repository.

  Please make sure you have the correct access rights
  and the repository exists."

plus that BRANCH.NOT.VERIFIED thing looks bad too (and is probably related).

         Linus
