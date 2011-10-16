Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1JPRkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 13:40:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44298 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1JPRkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 13:40:35 -0400
Subject: Re: OCFS2 1.6.0 for mainline?
From: Sasha Levin <levinsasha928@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4E9AF05B.7020508@gmail.com>
References: <4E9AF05B.7020508@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 16 Oct 2011 19:40:32 +0200
Message-ID: <1318786832.31522.21.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 16:55 +0200, Xose Vazquez Perez wrote:
> Richard Weinberger wrote:
> 
> > But the mainline kernel seems to contain only version 1.5.0.
> > 
> > Also the linux-next ocfs2 branch has only 1.5.0.
> > git://oss.oracle.com/git/jlbec/linux-2.6.git linux-next
> > 
> > Where can I get 1.6.0?
> > When will it come to mainline?
> 
> the latest is 1.8.0: http://public-yum.oracle.com/beta/repo/OracleLinux/OL6/uek2/x86_64/kernel-uek-2.6.39-100.0.12.el6uek.src.rpm
> 
> No patch, just look at linux-2.6.39/fs/ocfs2/
> 
> NO NO NO oracle!

Oracle's git tree for OCFS2 is available at
http://oss.oracle.com/git/?p=ocfs2-1.8.git;a=summary , and all the rest
of their open source related trees are at http://oss.oracle.com/git/ .

-- 

Sasha.

