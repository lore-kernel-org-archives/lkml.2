Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1HJBse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 21:48:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49189 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab1HJBsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 21:48:33 -0400
Subject: Re: linux-next: build failure after merge of the security-testing
 tree
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110810105840.cb0b3ac63c84b51b98029d8c@canb.auug.org.au>
References: <20110810105840.cb0b3ac63c84b51b98029d8c@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 21:48:29 -0400
Message-ID: <1312940909.2611.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 10:58 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the security-testing tree, today's linux-next build
> (powerpc ppc64_defconfig) failed like this:
> 
> fs/reiserfs/xattr_security.c: In function 'reiserfs_security_init':
> fs/reiserfs/xattr_security.c:69:2: error: implicit declaration of function 'security_old_inode_init_security'
> 
> Caused by commit 9d8f13ba3f48 ("security: new
> security_inode_init_security API adds function callback").  Forgotten
> include?
> 
> I have used the security-testing tree from next-20110809 for today.

No, I left out the stub definition in the include.  James, how do you
want me to correct this and the missing 'inline'?  Should I be updating
the original patches or submitting them as new patches?

thanks,

Mimi

