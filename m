Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab2EOPvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:51:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2EOPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:51:40 -0400
Date: Tue, 15 May 2012 08:51:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sage Ahn <syahn@gctsemi.com>
Cc: devel@driverdev.osuosl.org, olofj@chromium.org,
        linux-kernel@vger.kernel.org, benchan@chromium.org
Subject: Re: [PATCH v2] staging: gdm72xx: Add GCT GDM72xx WiMAX driver.
Message-ID: <20120515155136.GA24642@kroah.com>
References: <1337055636-17520-1-git-send-email-syahn@gctsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337055636-17520-1-git-send-email-syahn@gctsemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 01:20:36PM +0900, Sage Ahn wrote:
> This patch provides the kernel driver for the GDM72xx WiMAX chips
> developed by GCT Semiconductor, Inc., which enables mobile WiMAX
> connection on the Linux host.
> 
> Signed-off-by: Sage Ahn <syahn@gctsemi.com>
> Cc: Ben Chan <benchan@chromium.org>
> ---
> Fix license headers.

Much nicer, thanks for the quick turn-around, now applied.

greg k-h
