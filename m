Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab1FFHlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:41:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45288 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab1FFHlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=xqiEGHJWYHFyohuS9KMHk094GQNuABC7cIv8YENAm0v8P2i+TnquUBogODIR6DAcEg
         9uh8kdpdW019cCx2ONaluWP7wbOejI9RtNiJuU+IWlPL7ZRyyMexvxZ3WLMwhF7s+n/C
         wy9KKB/BtkIcjKxnYzJnMRh4UQCU9DkXTt9PU=
Subject: l2-mtd-2.6.git to linux-next
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 10:37:30 +0300
Message-ID: <1307345850.3135.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

as we've discussed, please, include l2-mtd-2.6.git tree to linux-next:

git://git.infradead.org/users/dedekind/l2-mtd-2.6.git master

David, Stephen would like to see your explicit ack.

To make a long story short, currently the MTD subsystem maintenance is a
team work:

1. David is the maintainer who has the ultimate authority to merge or
   reject patches, and who holds the biggest MTD experience/knowledge.

2. David is busy with other projects and has no time to routinely
   review patches and merge them to the mtd-2.6.git tree. And I help him
   with my "level 2" l2-mtd-2.6.git tree.

By including l2-mtd-2.6.git into linux-next we want to solve the
following problem: because of lack of time dwmw2 does not always merges
patches to the mtd-2.6.git tree, and often we are in a situation when
MTD patches are exposed to linux-next for a day or 2, during the merge
window, and then they are merged.

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

