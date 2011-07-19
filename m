Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1GSU5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:57:32 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49255 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab1GSU5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:57:30 -0400
Subject: Re: [PATCH v7 00/16] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
In-Reply-To: <alpine.LRH.2.00.1107190948540.16033@tundra.namei.org>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.1107190948540.16033@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 16:56:11 -0400
Message-ID: <1311108971.3374.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 09:52 +1000, James Morris wrote:
> The discussion on this seems to have run its course.
> 
> Does anyone have any further issues with these patches?
> 
> Otherwise, I will merge EVM.
> 
> 
> - James

James,

If/when you're ready to merge the EVM patches, they have been rebased
against the latest security-testing-2.6/#next and a couple of
whitespaces removed.  No other changes were made.

The following changes since commit 0f2a55d5bb2372058275b0b343d90dd5d640d045:

  TOMOYO: Update kernel-doc. (2011-07-14 17:50:03 +1000)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/zohar/ima-2.6.git next-evm

Dmitry Kasatkin (5):
      evm: add support for different security.evm data types
      evm: crypto hash replaced by shash
      evm: additional parameter to pass integrity cache entry 'iint'
      evm: evm_verify_hmac must not return INTEGRITY_UNKNOWN
      evm: replace hmac_status with evm_status

Mimi Zohar (11):
      security: new security_inode_init_security API adds function callback
      integrity: move ima inode integrity data management
      xattr: define vfs_getxattr_alloc and vfs_xattr_cmp
      evm: re-release
      security: imbed evm calls in security hooks
      evm: evm_inode_post_removexattr
      evm: imbed evm_inode_post_setattr
      evm: add evm_inode_init_security to initialize new files
      evm: call evm_inode_init_security from security_inode_init_security
      evm: permit only valid security.evm xattrs to be updated
      evm: add evm_inode_setattr to prevent updating an invalid security.evm

thanks,

Mimi

