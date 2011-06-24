Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1FXICs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 04:02:48 -0400
Received: from linux-sh.org ([111.68.239.195]:41884 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1FXICh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 04:02:37 -0400
Date: Fri, 24 Jun 2011 17:02:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pavel Shved <shved@ispras.ru>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH] hecubafb: add module_put on error path in hecubafb_probe()
Message-ID: <20110624080215.GB24184@linux-sh.org>
References: <1308327913-23220-1-git-send-email-shved@ispras.ru> <1308327913-23220-3-git-send-email-shved@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308327913-23220-3-git-send-email-shved@ispras.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 08:25:12PM +0400, Pavel Shved wrote:
> In hecubafb_probe(), after a successful try_module_get, vzalloc may
> fail and make the hecubafb_probe return, but the module is not put on
> this error path.
> 
> This patch adds an exit point that calls module_put in such situation.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Pavel Shved <shved@ispras.ru>

Applied, thanks.
