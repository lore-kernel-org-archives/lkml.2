Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab1GANWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:22:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab1GANWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:22:00 -0400
Date: Fri, 1 Jul 2011 15:21:58 +0200
From: Michal Marek <mmarek@suse.cz>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gitignore: ignore debian build directory
Message-ID: <20110701132158.GA25895@sepie.suse.cz>
References: <1309477370-5866-1-git-send-email-Gregory.Dietsche@cuw.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309477370-5866-1-git-send-email-Gregory.Dietsche@cuw.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 06:42:50PM -0500, Greg Dietsche wrote:
> Have git ignore the Debian directory created when running:
> 	make deb-pkg
> 
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>

Thanks, applied to kbuild-2.6.git#misc.

Michal
