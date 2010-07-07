Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab0GGRBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:01:09 -0400
Received: from fieldses.org ([174.143.236.118]:40452 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab0GGRBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:01:07 -0400
Date: Wed, 7 Jul 2010 13:00:58 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-nfs@vger.kernel.org
Subject: Re: [PATCH 06/10] NFSv4: Add label recommended attribute and NFSv4
 flags
Message-ID: <20100707170058.GD28815@fieldses.org>
References: <1278513086-23964-1-git-send-email-dpquigl@tycho.nsa.gov>
 <1278513086-23964-7-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278513086-23964-7-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 10:31:22AM -0400, David P. Quigley wrote:
> This patch adds a new recommended attribute named label into the NFSv4 file

Make that '... recommended attribute named "security_label"' ?

> +#define NFS4_MAXLABELLEN	4096

Idle curiosity--why 4096?  (Why couldn't it be 16?  And how do we know
people will never want 8192?)

> +#define NFSEXP_SECURITY_LABEL	0x0040  /* Support security label fattr4 */

I guess that answers my earlier question.

--b.
