Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2JSNSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:18:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34245 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2JSNSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:18:15 -0400
Date: Fri, 19 Oct 2012 14:18:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] unicore32: switch to generic
 kernel_thread()/kernel_execve()
Message-ID: <20121019131811.GJ2616@ZenIV.linux.org.uk>
References: <1350636190-6303-1-git-send-email-gxt@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350636190-6303-1-git-send-email-gxt@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 04:43:09PM +0800, Guan Xuetao wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Acked-and-Tested-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

You mean, it worked modulo obvious missing ')'?  Wow... OK, merged
into signal.git#for-next, obviously in no-rebase mode (as the matter
of fact, I'm dropping the local branch completely).
