Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2BYAR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 19:17:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab2BYAR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 19:17:58 -0500
Date: Sat, 25 Feb 2012 01:17:56 +0100
From: Michal Marek <mmarek@suse.cz>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kbuild: Makefile: clean up samples directory
Message-ID: <20120225001756.GF19992@sepie.suse.cz>
References: <1328349359-29524-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328349359-29524-1-git-send-email-dev@snitselaar.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 02:55:59AM -0700, Gerard Snitselaar wrote:
> Playing around with make randconfig I ended up with CONFIG_SAMPLES
> set. After cleaning up the build I noticed that git status was
> showing samples/hidraw/hid-example as an untracked file.
> 
> Adding samples to clean-dirs seems to solve the problem, but
> I don't know if that is the correct way to solve the issue.

It is. I applied your patch to kbuild.git#kbuild now.

Michal
