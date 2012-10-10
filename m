Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2JJBwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:52:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33589 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2JJBws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:52:48 -0400
Message-ID: <1349833967.5068.1.camel@anime-power2>
Subject: Re: ASpeed Technologies KMS VGA Driver error in log
From: thekingmen <thekingmen@gmail.com>
To: David Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Oct 2012 21:52:47 -0400
In-Reply-To: <1971642771.16545834.1346619658976.JavaMail.root@redhat.com>
References: <1971642771.16545834.1346619658976.JavaMail.root@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ----- Original Message -----
> > From: "Keven" <thekingmen@gmail.com>
> > To: linux-kernel@vger.kernel.org, airlied@redhat.com
> > Sent: Monday, 3 September, 2012 12:26:05 AM
> > Subject: ASpeed Technologies KMS VGA Driver error in log
> > 
> > 1. ASpeed Technologies KMS VGA Driver error in log
> > 2. Hi, I have an error message in my kernel log and I don't know if
> > this
> > need to be taken care of or this is a normal behaviour.
> > 
> > The component is [PATCH] drm: Initial KMS driver for AST (ASpeed
> > Technologies) 2000 series
> > This article is related to the new compoent.
> > http://lists.freedesktop.org/archives/dri-devel/2012-April/021578.html
> > 
> > The code file should be
> > Linux/drivers/gpu/drm/ast/ast_mode.c
> > 
> > The error I have is
> > [    7.518793] [drm:ast_cursor_init] *ERROR* pinned cursor cache at 0
> > 
> 
> Oh thanks for pointing this out, its just left over debug, I'll send a patch
> to remove it.
> 
> Dave.

Hello, 
I see no changes in the current kernel tree. Maybe you forgot about
it ? 

