Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2KURot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:44:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab2KURor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:44:47 -0500
Date: Wed, 21 Nov 2012 18:44:45 +0100
From: Jan Kara <jack@suse.cz>
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Tagging of -stable patches
Message-ID: <20121121174445.GE30250@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  I have a question regarding tagging of patches targetted in -stable
kernels. We have this 'CC: stable@vger.kernel.org # something' tag. Now
inconvenient thing is that when I create a patch and have such tag in it,
then git-send-email will mangle the address because of the #. Now even if
git-send-email started to ignore the part after #, we don't really want
stable@vger.kernel.org to get the patch since it is eligible for -stable
only after it is merged upstream. So the CC form of the tag seems to be
kind of inconvenient. Won't it be better to have some different tag?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
