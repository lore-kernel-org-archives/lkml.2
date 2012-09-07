Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2IGSWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:22:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51863 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2IGSWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:22:11 -0400
Date: Fri, 7 Sep 2012 19:22:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] status of execve() work - per-architecture patches
 solicited
Message-ID: <20120907182210.GF13973@ZenIV.linux.org.uk>
References: <20120907182004.GE13973@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907182004.GE13973@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 07:20:04PM +0100, Al Viro wrote:
> 	To architecture maintainers: please, review the current
> situation in git.kernel.org/pub/scm/linux/kernel/git/viro/signal #execve2

It should be commit 50343ee2889f5a8cff1aa30110f07b0e01563500 right now.
