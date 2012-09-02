Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2IBVBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:01:01 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:60636 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab2IBVBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:01:00 -0400
Date: Sun, 2 Sep 2012 17:00:58 -0400 (EDT)
From: David Airlie <airlied@redhat.com>
To: Keven <thekingmen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <1971642771.16545834.1346619658976.JavaMail.root@redhat.com>
In-Reply-To: <1346595965.3941.1.camel@anime-power2>
Subject: Re: ASpeed Technologies KMS VGA Driver error in log
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.51.158]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Keven" <thekingmen@gmail.com>
> To: linux-kernel@vger.kernel.org, airlied@redhat.com
> Sent: Monday, 3 September, 2012 12:26:05 AM
> Subject: ASpeed Technologies KMS VGA Driver error in log
> 
> 1. ASpeed Technologies KMS VGA Driver error in log
> 2. Hi, I have an error message in my kernel log and I don't know if
> this
> need to be taken care of or this is a normal behaviour.
> 
> The component is [PATCH] drm: Initial KMS driver for AST (ASpeed
> Technologies) 2000 series
> This article is related to the new compoent.
> http://lists.freedesktop.org/archives/dri-devel/2012-April/021578.html
> 
> The code file should be
> Linux/drivers/gpu/drm/ast/ast_mode.c
> 
> The error I have is
> [    7.518793] [drm:ast_cursor_init] *ERROR* pinned cursor cache at 0
> 

Oh thanks for pointing this out, its just left over debug, I'll send a patch
to remove it.

Dave.
