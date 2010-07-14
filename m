Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0GNKDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:03:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab0GNKDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:03:34 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH v2] drivers: code cleanups
Date: Wed, 14 Jul 2010 12:02:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, "Jike Song" <albcamus@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1279100576-8680-1-git-send-email-xiaosuo@gmail.com>
In-Reply-To: <1279100576-8680-1-git-send-email-xiaosuo@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007141202.46492.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 14. Juli 2010, 11:42:56 schrieb Changli Gao:
> drivers: code cleanups
> 
> the first three goto clauses caused kfree(NULL), and the error code returned
> by kset->uevent_ops->uevent() wasn't passed to the caller of show_uevent().
> This patch also eliminates the unnecessary initializations of env and count.

This is not a good idea.
If you are indeed fixing a bug of not returning an error, make a patch that does that.
The other parts of your patch really are no improvement, because they make
things harder to maintain if additional cleanups or locking must ever be added.

	Regards
		Oliver
