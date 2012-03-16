Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422671Ab2CPJLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:11:09 -0400
Received: from science.horizon.com ([71.41.210.146]:21060 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932408Ab2CPJLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:11:07 -0400
Date: 16 Mar 2012 05:11:05 -0400
Message-ID: <20120316091105.28264.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jack@suse.cz, linux@horizon.com
Subject: Re: Oops in ext3_block_to_path.isra.40+0x26/0x11b
Cc: jkosina@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
In-Reply-To: <20120316085231.GA24821@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  Thanks for report!

Thanks for looking at it.

>  Hmm, is any mounting & unmounting happening during your backup?

No, none.  It's a simple BackupPC via rsync.
