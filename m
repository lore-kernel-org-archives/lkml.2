Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2CUPdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:33:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44709 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab2CUPdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:33:21 -0400
Date: Wed, 21 Mar 2012 08:33:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux-sh <linux-sh@vger.kernel.org>,
        Adrian McMenamin <adrianmcmenamin@gmail.com>
Subject: Re: [PATCH] VMUFAT filesystem [1/4]
Message-ID: <20120321153317.GA30250@kroah.com>
References: <CAN628AFKSgd2nKY5Ga7JqhVWqAySRW8OpeLyykOwocn4K_a-qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN628AFKSgd2nKY5Ga7JqhVWqAySRW8OpeLyykOwocn4K_a-qQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 12:30:36PM +0800, Adrian McMenamin wrote:
> >From d587b09573c06309bb2c3ef12223b77fffc3a922 Mon Sep 17 00:00:00 2001
> From: Adrian McMenamin <adrianmcmenamin@gmail.com>
> Date: Wed, 21 Mar 2012 12:17:51 +0800
> Subject: [PATCH] Add vmufat filesystem
> 
> ---

Hint, read Documentation/SubmittingPatches for how to properly create
patches that could be applied, if they were in mergable state (you
forgot the changelog entry, signed-off-by line, and probably a few other
things...)

