Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab0GTPwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:52:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:35404 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461Ab0GTPwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:52:16 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 00/16]  New ACL format for better NFSv4 acl interoperability
Date: Tue, 20 Jul 2010 17:52:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, adilger@sun.com, sandeen@redhat.com,
        tytso@mit.edu, bfields@citi.umich.edu, jlayton@redhat.com,
        linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <201007201211.53289.agruen@suse.de> <m3y6d6b2iv.fsf@linux.vnet.ibm.com>
In-Reply-To: <m3y6d6b2iv.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007201752.13377.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 July 2010 17:23:36 Aneesh Kumar K. V wrote:
> The userspace change did result in a different output [...]

Yes, this is expected -- we now leave acls alone more often.

Thanks,
Andreas
