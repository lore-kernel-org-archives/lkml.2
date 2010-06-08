Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0FHReu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:34:50 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:46460 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab0FHRes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:34:48 -0400
X-Greylist: delayed 2178 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jun 2010 13:34:48 EDT
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Subject: Labeled-NFS: Security Label support in NFSv4 
Date: Tue,  8 Jun 2010 12:22:46 -0400
Message-Id: <1276014176-20315-1-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been quite a while since the last time we submitted a patch set to the
mailing list for review. I met with Trond at the last IETF meeting and he
suggested that we resubmit the patches for review since the IETF process has
moved along since the last posting. When reviewing the code please be critical
of it. If you want a tree with the patches already applied we have posted a
public git tree that is ready for cloning and use. This tree can be found at
http://git.selinuxproject.org/git and can be cloned with the command below. You
can also find information on how to setup a labeled nfs mount at
http://www.selinuxproject.org/page/Labeled_NFS however the putclientlabel mount
option specified in the setup document is no longer supported.

git-clone git://git.selinuxproject.org/~dpquigl/lnfs.git


