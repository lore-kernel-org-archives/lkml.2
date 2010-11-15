Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0KOEtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 23:49:31 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34733 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331Ab0KOEt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 23:49:29 -0500
Date: Mon, 15 Nov 2010 13:48:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH] fsl-diu-fb: drop dead ioctl define
Message-ID: <20101115044856.GB8489@linux-sh.org>
References: <1289631987-5854-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289631987-5854-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 02:06:27AM -0500, Mike Frysinger wrote:
> The fsl-diu-fb driver no longer uses this define, and we have a common one
> to cover this already (FBIO_WAITFORVSYNC).
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Queued for .37.
