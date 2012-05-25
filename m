Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2EYTT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:19:29 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43248 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752900Ab2EYTTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:19:25 -0400
Date: Fri, 25 May 2012 14:24:46 -0500
From: Ben Myers <bpm@sgi.com>
To: Chen Baozi <baozich@gmail.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] xfs: fix typo in comment of xfs_dinode_t.
Message-ID: <20120525192445.GW16099@sgi.com>
References: <D347A332-0256-43E4-8FCE-BCFC1DD478C8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D347A332-0256-43E4-8FCE-BCFC1DD478C8@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 12:48:47AM +0800, Chen Baozi wrote:
> There should be "XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR" instead
> of "XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR".
> 
> Signed-off-by: Chen Baozi <baozich@gmail.com>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Committed.  Thanks for the patch Chen!

Signed-off-by: Ben Myers <bpm@sgi.com>
