Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0KMLKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 06:10:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46773 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0KMLKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 06:10:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u9FyksGJG64NKUCwEAwaWP1viOKBvBhCYkVRU0PhEVcD3S0znccffD/x7UP71cffpY
         WLKWhpr+VTq/iH+q0dAeZLQUL6AeM99wunDg0ai6SzZsXNHe9nKuM3cGWsJQAnD4e1mL
         S7umOPHaT/67T7exfkM25lE4Yz6lf9fTBX8aI=
Subject: Re: [PATCH 1/5] mtd: fix bdev exclusive open bugs in
 block2mtd::add_device()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-mtd@lists.infradead.org
In-Reply-To: <4CDE6BB2.5070806@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
	 <1288628129-12811-2-git-send-email-tj@kernel.org>
	 <1289644735.2218.8.camel@localhost>  <4CDE6BB2.5070806@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 13:10:34 +0200
Message-ID: <1289646634.2218.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 11:42 +0100, Tejun Heo wrote:
> Hmmm... not really.  The patch is small enough and splitting it won't
> really buy as any better bisectability.  Splitting patches into
> logical changes is a good thing but it's no religious dogma.  Let's
> apply it to the point it actually helps.

Well, it is more about if your second fix is buggy, we could revert it
without reverting the first fix. But anyway, this is not a big deal, so
let's forget about this indeed.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

