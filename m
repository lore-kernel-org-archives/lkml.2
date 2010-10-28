Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0J1MR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:17:59 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:58704 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab0J1MR6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:17:58 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Oct 2010 08:17:58 EDT
X-AuditID: 12074425-b7c98ae000000a04-56-4cc968c8fdee
Subject: Re: -tip: origin tree build failure (was: [GIT PULL] ext4 update for 2.6.37)
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20101028075631.GA7690@elte.hu>
Date: Thu, 28 Oct 2010 08:12:50 -0400
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <698D7018-682F-4D8A-A3A6-079514669D9F@mit.edu>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop> <20101028075631.GA7690@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28, 2010, at 3:56 AM, Ingo Molnar wrote:

> 
> hi Ted,
> 
>> Theodore Ts'o (18):
>>      ext4: rename {exit,init}_ext4_*() to ext4_{exit,init}_*()
> 
> Today's -tip fails to build due to upstream commit 5dabfc7 ("ext4: rename 
> {exit,init}_ext4_*() to ext4_{exit,init}_*()"), on all[yes/mod]config with 
> CONFIG_EXT4_FS_XATTR disabled:
> 
>  fs/ext4/super.c:4776: error: implicit declaration of function ‘ext4_init_xattr’
> 
> Commit 5dabfc7 renamed init_ext4_xattr to ext4_init_xattr but forgot to update the 
> definition in fs/ext4/xattr.h. The patch below fixes it.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks for catching this, my bad.

-- Ted

