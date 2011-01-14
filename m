Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab1ANOsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:48:06 -0500
Received: from mail-ww0-f66.google.com ([74.125.82.66]:62874 "EHLO
	mail-ww0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab1ANOr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:47:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=VQIxycLzbZF9jff8fBZN4gQMjWWWn1W0KfTrkVlDJjLXwlspzUEGuylUC9U9tUy6aK
         YYzX0LrWIduTwth388RHYDRcg1f33tkS7xaC6rOipNOoaDEQWklNmia05f6yeWnpdPSZ
         xmfpAuv15xZ4ebq15hr05AWhdLAD5hwOkFerk=
MIME-Version: 1.0
Date: Sat, 15 Jan 2011 01:47:58 +1100
Message-ID: <AANLkTinSdXzchfLB75ZY=mkVdyqn6o_7-zyxBMdNxJZM@mail.gmail.com>
Subject: Please pull vfs-scale-working tree
From: Nick Piggin <npiggin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git tree is here:

 git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git

Branch is:

   vfs-scale-working

Head:
32385c7cf60a78375b63afc4f02001df84dfd1a0

Diffstat:
 fs/namei.c              |   37 +++++++++++++++++++------------------
 include/linux/list_bl.h |    2 +-
 kernel/cgroup.c         |    2 +-
 3 files changed, 21 insertions(+), 20 deletions(-)

Contains 2 more bugfixes, and a missing lockdep annotation.
Many thanks to reviewers and testers.

Thanks,
Nick
