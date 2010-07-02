Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0GBAQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:16:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:44020 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab0GBAQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:16:06 -0400
Date: Fri, 2 Jul 2010 10:16:01 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] security: move LSM xattrnames to xattr.h
In-Reply-To: <1278011263-7951-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1007021015490.2400@tundra.namei.org>
References: <1278011263-7951-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010, Mimi Zohar wrote:

> Make the security extended attributes names global. Updated to move
> the remaining Smack xattrs.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Acked-by: Serge Hallyn <serue@us.ibm.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
