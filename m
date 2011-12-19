Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1LSBMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 20:12:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40122 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1LSBMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 20:12:49 -0500
Date: Mon, 19 Dec 2011 01:12:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20111219011248.GF2203@ZenIV.linux.org.uk>
References: <20111219120613.2da854bacb6d6686248bb945@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219120613.2da854bacb6d6686248bb945@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 12:06:13PM +1100, Stephen Rothwell wrote:

> And many more similar.
> 
> Probably caused by commit 3073cb2e813c ("trim security.h") which
> presumably removed an include file that was including err.h :-(
> 
> I have used the vfs tree from next-20111216 for today.

Fixed and pushed...
