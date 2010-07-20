Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210Ab0GTKL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 06:11:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab0GTKL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 06:11:56 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 00/16]  New ACL format for better NFSv4 acl interoperability
Date: Tue, 20 Jul 2010 12:11:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, adilger@sun.com, sandeen@redhat.com,
        tytso@mit.edu, staubach@redhat.com, bfields@citi.umich.edu,
        jlayton@redhat.com, linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <201007192119.50868.agruen@suse.de> <m34ofucxes.fsf@linux.vnet.ibm.com>
In-Reply-To: <m34ofucxes.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007201211.53289.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 July 2010 11:31:07 Aneesh Kumar K. V wrote:
> We need to update ACL4_VALID_FLAGS to now consider ACL4_MASKED as a
> valid flag.  This is also needed for userspace.

Good point, I missed that.

> On a related note, should we move ACL4_MASKED and ACL4_POSIX_MAPPED to
> be the higher bits ? That would make sure we will be able to accomodate
> new flag value NFSv4 define.

That makes sense, except that ACL4_POSIX_MAPPED hasn't entered the scene in 
the patches posted here, and I'm still not convinced that we'll actually need 
it.

Thanks,
Andreas
