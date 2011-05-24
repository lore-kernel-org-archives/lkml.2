Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1EXQiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:38:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1EXQio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:38:44 -0400
Date: Tue, 24 May 2011 18:38:42 +0200
From: Michal Marek <mmarek@suse.cz>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] kbuild: Create a kernel-headers RPM
Message-ID: <20110524163842.GE2276@sepie.suse.cz>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
 <1305653779-3445-3-git-send-email-asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305653779-3445-3-git-send-email-asharma@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:36:16AM -0700, Arun Sharma wrote:
> To compile binaries which depend on new kernel interfaces, we need a
> kernel-headers RPM
> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> ---
>  scripts/package/mkspec |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)

Pushed to kbuild-2.6.git#packaging.

Thanks,
Michal
