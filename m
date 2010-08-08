Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0HHQEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 12:04:31 -0400
Received: from THUNK.ORG ([69.25.196.29]:36440 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0HHQE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 12:04:28 -0400
Date: Sun, 8 Aug 2010 12:04:04 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V17 10/12] vfs: Export file system uuid via
 /proc/<pid>mountinfo
Message-ID: <20100808160404.GC3635@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
	corbet@lwn.net, neilb@suse.de, npiggin@suse.de,
	hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu,
	linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
	philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
References: <1279566727-16598-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1279566727-16598-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279566727-16598-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stupid nit-pick in the subject line/patch summary:

s;/proc/<pid>mountinfo;/proc/<pid>/mountinfo;

						- Ted
