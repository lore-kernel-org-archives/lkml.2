Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0HQAT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 20:19:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44425 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0HQATz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 20:19:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=f1CYgRY6bzusyAyllN1w+1ouWKQQaAvIAOGzh2FVv+aU+zB5KXA+owFOmF2RZFwRov
         LIotbBLsXesLOIrvvGdRFYozWuo5Cdm9/1wYVSPMp/4naGGiqOtVmgxGD2uYF+vbWgTa
         8nwjqtCqS7F1jA0p9PQd2P10HNGZUEfDYLPDM=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 16 Aug 2010 17:19:34 -0700
Message-ID: <AANLkTimueu1RYQ4MAB1ErdW6y+=A5Nd310zDd05_myaC@mail.gmail.com>
Subject: Compat-wireless for 2.6.36-rc1 release
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus released 2.6.36-rc1 over the weekend. We've been following the
next kernel's development cycle through the master branch of both
compat-wireless.git and compat.git. I just created the branch for each
of those git trees for the 2.6.36.y release and put up the first
tarball for testing purposes:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/compat-wireless-2.6.36-rc1-1.tar.bz2

Note that the extra -1 here accounts for the fact that we can have bug
fixes within compat-wireless.git and/or comat.git during one extra
version of the kernel or even during one rc release.You can find the
ChangeLog of what went in to this kernel by reading this:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/ChangeLog-2.6.36-rc1-wireless

Please report any issues, remember this is a stable kernel so if there
is a bug it should be reported ASAP.

compat-wireless code metrics

    494638 - Total upstream lines of code being pulled
      1699 - backport code changes
      1460 - backport code additions
       239 - backport code deletions
      5979 - backport from compat module
      7678 - total backport code
    1.5522 - % of code consists of backport work

Base tree: linux-2.6-allstable.git
Base tree version: v2.6.36-rc1
compat-wireless release: compat-wireless-v2.6.36-rc1

If you have a bug fix for compat-wireless.git which also applies down
to the linux-2.6.36.y branch or a patch for compat.git that applies to
its respective linux-2.6.36.y branch please indicate it on the patch
you send. You can do so by marking the patch with this on the commit
log:

Applies-to: linux-2.6.35.y

for example if the fix was also required for the 2.6.35.y branch. You
can specify branch ranges as well.

Applies-to: linux-2.6.32.y-linux-2.6.35.y

I'll send out a full ChangeLog of the compat-wireless.git and
compat.git contributions for this release once we bake the final
2.6.36 release along with Linus.

This goes compile and load tested with ath9k using a 3x3 AR9003 card on 2.6.32.

  Luis
