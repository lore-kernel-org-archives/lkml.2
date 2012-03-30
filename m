Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936498Ab2C3W2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:28:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935618Ab2C3W1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:27:54 -0400
Date: Fri, 30 Mar 2012 15:24:15 +0200
From: Michal Marek <mmarek@suse.cz>
To: Shawn Landden <shawnlandden@gmail.com>
Cc: andi@lisas.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: scripts/patch-kernel should be able to digest
 kernel.org hosted .xz patches
Message-ID: <20120330132414.GC11444@sepie.suse.cz>
References: <1331590417-10050-1-git-send-email-shawnlandden@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331590417-10050-1-git-send-email-shawnlandden@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 03:13:37PM -0700, Shawn Landden wrote:
> kernel.org is hosting patches and kernel compressed with xz (lzma2+). Allow
> scripts/patch-kernel to decompress these files.
> 
> Signed-off-by: Shawn Landden <shawnlandden@gmail.com>
> ---
>  scripts/patch-kernel |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)

Applied to kbuild.git#misc, thanks.

Michal
