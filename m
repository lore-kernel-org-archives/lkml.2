Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1KHD7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:59:38 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59569 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1KHD7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:59:36 -0500
Date: Mon, 7 Nov 2011 19:59:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <dgdunix@gmail.com>
Subject: Re: [PATCH v2] Input: convert obsolete strict_strtox to kstrtox
Message-ID: <20111108035930.GC21927@core.coreip.homeip.net>
References: <1320666890-29615-1-git-send-email-jj_ding@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320666890-29615-1-git-send-email-jj_ding@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 07:54:50PM +0800, JJ Ding wrote:
> From: JJ Ding <dgdunix@gmail.com>
> 
> With commit 67d0a0754455f89ef3946946159d8ec9e45ce33a we mark strict_strtox
> as obsolete. Convert all remaining such uses in drivers/input/.
> 
> Also change the data type from long to int as Dmitry sugguests, we now have
> kstrtouint which suits these uses better.
> 

Applied, thanks JJ.

-- 
Dmitry
