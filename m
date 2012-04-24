Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2DXBkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:40:01 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:40966 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150Ab2DXBj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:39:59 -0400
Date: Mon, 23 Apr 2012 21:39:56 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Eldad Zack <eldad@fogrefinery.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [EXT4] super.c: unused variable warning without
 CONFIG_QUOTA
Message-ID: <20120424013956.GB18865@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Eldad Zack <eldad@fogrefinery.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1335109852-17829-1-git-send-email-eldad@fogrefinery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1335109852-17829-1-git-send-email-eldad@fogrefinery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 05:50:52PM +0200, Eldad Zack wrote:
> sb info is only checked with quota support.
> 
> fs/ext4/super.c: In function ‘parse_options’:
> fs/ext4/super.c:1600:23: warning: unused variable ‘sbi’ [-Wunused-variable]
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

Thanks, applied.

					- Ted
