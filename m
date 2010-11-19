Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0KSNFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:05:35 -0500
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:54525 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746Ab0KSNFe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:05:34 -0500
X-AuditID: 1209190d-b7cacae000000a14-be-4ce6761d32ab
Subject: Re: [PATCH] ext3: Coding style fix in namei.c
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
Date: Fri, 19 Nov 2010 08:05:29 -0500
Cc: Namhyung Kim <namhyung@gmail.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <093B58FD-0DA7-4E94-A70E-C926EC6D02F6@mit.edu>
References: <1290161589-5370-1-git-send-email-namhyung@gmail.com> <60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
To: Theodore Tso <tytso@MIT.EDU>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oooh, I forgot another downside which just came to mind:

* Call of this code churn to fix whitespace all for the sake of keep some damned checkpatch.pl script happy also breaks "git blame" reports.

-- Ted

