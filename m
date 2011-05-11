Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab1EKQ1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:27:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab1EKQ1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:27:22 -0400
Date: Wed, 11 May 2011 13:41:49 +0200
From: Michal Marek <mmarek@suse.cz>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-kbuild@vger.kernel.org, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Fix GNU make v3.80 compatibility
Message-ID: <20110511114149.GH13293@sepie.suse.cz>
References: <612917f85f003cc05dbd3420ec718bc4@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <612917f85f003cc05dbd3420ec718bc4@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 03:47:16PM -0700, Kevin Cernekee wrote:
> According to Documentation/Changes, the kernel should be buildable with
> GNU make 3.80+.  Commit 88d7be031f9f975bb3f50a0b5ef3796a671e7edf (kbuild:
> Use a single clean rule for kernel and external modules) introduced the
> "$(or" construct, which requires make 3.81.  This causes "make clean" to
> malfunction when it is used with external modules.
> 
> Replace "$(or" with an equivalent "$(if" expression, to restore backward
> compatibility.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> Cc: stable@kernel.org

Pushed to kbuild-2.6.git#kbuild, thanks.

Michal
