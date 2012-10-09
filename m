Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2JIRou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:44:50 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54640 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab2JIRos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:44:48 -0400
Date: Tue, 9 Oct 2012 13:44:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        osd-dev@open-osd.org, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/8] exofs: drop lock/unlock super
Message-ID: <20121009174440.GB29339@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Marco Stornelli <marco.stornelli@gmail.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Benny Halevy <bhalevy@tonian.com>, osd-dev@open-osd.org,
	linux-kernel@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <50700A1A.7@gmail.com>
 <50734C6D.2000400@panasas.com>
 <20121008232447.GR2616@ZenIV.linux.org.uk>
 <507448E0.4040305@gmail.com>
 <20121009164040.GV2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009164040.GV2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to confirm, the ext4 lock_super removal is commit 07724f98978a,
and Linus has already pulled it into his tree.

    	      	      	     	     - Ted
