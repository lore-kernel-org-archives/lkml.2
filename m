Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1JPXYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 19:24:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53086 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1JPXYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 19:24:31 -0400
Subject: Re: OCFS2 1.6.0 for mainline?
From: Sasha Levin <levinsasha928@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4E9B55B8.3090700@gmail.com>
References: <4E9AF05B.7020508@gmail.com> <1318786832.31522.21.camel@lappy>
	 <4E9B55B8.3090700@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 17 Oct 2011 01:24:25 +0200
Message-ID: <1318807465.31522.24.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 00:07 +0200, Xose Vazquez Perez wrote:
> On 10/16/2011 07:40 PM, Sasha Levin wrote:
> 
> > On Sun, 2011-10-16 at 16:55 +0200, Xose Vazquez Perez wrote:
> 
> >> the latest is 1.8.0: http://public-yum.oracle.com/beta/repo/OracleLinux/OL6/uek2/x86_64/kernel-uek-2.6.39-100.0.12.el6uek.src.rpm
> >>
> >> No patch, just look at linux-2.6.39/fs/ocfs2/
> >>
> >> NO NO NO oracle!
> 
> > Oracle's git tree for OCFS2 is available at
> > http://oss.oracle.com/git/?p=ocfs2-1.8.git;a=summary , and all the rest
> > of their open source related trees are at http://oss.oracle.com/git/ .
> 
> last change in git was *ONE year* ago: 12 Oct 2010
> kernel-uek-2.6.39-100.0.12.el6uek.src.rpm is two weeks old.
> Are you sure is the same code in git and src.rpm ?

You're right, that source rpm is based on
http://oss.oracle.com/git/?p=linux-2.6-unbreakable-beta.git
which also has more recent OCFS2 commits.

> 
> 
> Are going oracle to play also this way with btrfs ?

-- 

Sasha.

