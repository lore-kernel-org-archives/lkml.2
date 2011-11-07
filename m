Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1KGFzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 00:55:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61908 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1KGFzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 00:55:45 -0500
Date: Sun, 6 Nov 2011 21:55:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <dgdunix@gmail.com>
Subject: Re: [PATCH] Input: convert obsolete strict_strtox to kstrtox
Message-ID: <20111107055540.GB21095@core.coreip.homeip.net>
References: <1320635570-18860-1-git-send-email-jj_ding@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320635570-18860-1-git-send-email-jj_ding@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JJ,

On Mon, Nov 07, 2011 at 11:12:50AM +0800, JJ Ding wrote:
> From: JJ Ding <dgdunix@gmail.com>
> 
> With commit 67d0a0754455f89ef3946946159d8ec9e45ce33a we mark strict_strtox
> as obsolete. Convert all remaining such uses in drivers/input/.

Most of these users do not want long data, they just want an int, but
strict_strtouint was not available. Since we have kstrtouint now it
would be nice to use it.

Thanks.

-- 
Dmitry
