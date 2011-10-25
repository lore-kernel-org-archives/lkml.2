Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1JYIhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:37:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59608 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab1JYIhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:37:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the pm tree with the s390 tree
Date: Tue, 25 Oct 2011 10:39:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20111025182025.d57f82a57ceaa8fae7cc5127@canb.auug.org.au>
In-Reply-To: <20111025182025.d57f82a57ceaa8fae7cc5127@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110251039.46327.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 25, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> arch/s390/kernel/suspend.c between commit 4de2166b1804 ("[S390] sparse:
> fix sparse warnings about missing prototypes") from the s390 tree and
> commit 85055dd805f0 ("PM / Hibernate: Include storage keys in hibernation
> image on s390") from the pm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

The fix looks correct to me, so please carry it going forward (unless
Martin decides to pull it into his tree).

Thanks,
Rafael
