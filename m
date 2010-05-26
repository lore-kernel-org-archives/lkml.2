Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078Ab0EZAly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 20:41:54 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:56142 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab0EZAlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 20:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=jHcB9gYzSr4Ii3OPKBR5Cr1EJ+6iXp0KMkZGJr3tR+6uJagwadqcrAd2BmHcwAQrI0
         8+7ReJcQeV94A3jQGKeit52C8xzmrdXWbYdBeRyE2u5/NuNeIo9wZYsuaiKr91oBFNux
         0/fIjibcFdCqI1XFF7bYI9/Eo80YGO5FUMkLo=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 25 May 2010 17:41:28 -0700
Message-ID: <AANLkTilZCdt-YGLsAOd14qvaGRzl7iJa2r-wi5xljhTr@mail.gmail.com>
Subject: Compat-wireless tarballs with pending and crap patches
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Ivan Seskar <Seskar@winlab.rutgers.edu>,
       Shridatt James Sugrim <shridatt.sugrim@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I added a way for compat-wireless to have pending and crap
patches applied I figured I'd automate the creation of the same
tarballs. The tarballs are hosted on Orbit as well in the same
location as the regular tarballs. So we have for today for example:

compat-wireless-2010-05-25.tar.bz2       - The usual linux-next based
tarball for 802.11 and BT
compat-wireless-2010-05-25-p.tar.bz2	 - The usual linux-next based
tarball + patches from linux-next-pending/
compat-wireless-2010-05-25-pc.tar.bz2  -
compat-wireless-2010-05-25-p.tar.bz2 + patches from crap/

Since we're in the merge window the pending stuff is a bit big and it
just includes stuff in Atheros' queue. Feel free to poke at me to
apply anything else, just e-mail me, hopefully in reply to the
upstream posted patch. If there's a better way to do this we will
figure it out I guess.

FWIW the new code metrics for the pc release is:

compat-wireless code metrics

    491620 - Total upstream code being pulled
      1393 - backport code changes
      1163 - backport code additions
       230 - backport code deletions
      5679 - backport from compat module
      7072 - total backport code
      1.44 - % of code consists of backport work
      7132 - Code changes posted but not yet merged
      4449 - Code additions posted but not yet merged
      2683 - Code deletions posted but not yet merged
      1.45 - % of code not yet merged
      1225 - Crap changes not yet posted
      1181 - Crap additions not yet merged
        44 - Crap deletions not yet posted
      0.25 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100525
compat-wireless release: compat-wireless-20100525

The backport metrics should now be a bit more correct, so I do guess
1.44% code for this release is backport work, this includes C code,
header files and the code changed by the patches. The pending code is
a bit high due to the merge window, and the crap stuff hasn't moved.
These stats will always be available on the code-metrics.txt file for
each tarball. For the "p" release you will not see the metrics for the
crap, and for the regular tarball you will not see the pending stats
nor the crap stats.

  Luis
