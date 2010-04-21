Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0DUWBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:01:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34149 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab0DUWBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:01:05 -0400
Date: Wed, 21 Apr 2010 14:58:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/14] EVM
Message-Id: <20100421145848.b36ab7bd.randy.dunlap@oracle.com>
In-Reply-To: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090202.4BCF7599.008C:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010 17:49:40 -0400 Mimi Zohar wrote:

> Extended Verification Module(EVM) detects offline tampering of the
> security extended attributes (e.g. security.selinux, security.SMACK64,
> security.ima), which is the basis for LSM permission decisions and,
> with this set of patches, integrity appraisal decisions. To detect
> offline tampering of the extended attributes, EVM maintains an
> HMAC-sha1 across a set of security extended attributes, storing the
> HMAC as the extended attribute 'security.evm'. To verify the integrity
> of an extended attribute, EVM exports evm_verifyxattr(), which
> re-calculates the HMAC and compares it with the version stored in
> 'security.evm'.
> 
...
> 
> Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
> reviewing the patches.
> 
> Mimi
> 
> Mimi Zohar (14):
>   integrity: move ima inode integrity data management
>   security: move LSM xattrnames to xattr.h
>   xattr: define vfs_getxattr_alloc and vfs_xattr_cmp
>   evm: re-release
>   ima: move ima_file_free before releasing the file
>   security: imbed evm calls in security hooks
>   evm: inode post removexattr
>   evm: imbed evm_inode_post_setattr
>   evm: inode_post_init
>   fs: add evm_inode_post_init calls
>   ima: integrity appraisal extension
>   ima: appraise default rules
>   ima: inode post_setattr
>   ima: add ima_inode_setxattr and ima_inode_removexattr
> --

A summary diffstat would be good to see in patch 00/14.

Lacking that, at least each individual patch should have a diffstat summary
in it.  Please read Documentation/SubmittingPatches.

---
~Randy
