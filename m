Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab2JWNIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:08:52 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64172 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab2JWNIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <1350996776-17864-2-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1350996776-17864-1-git-send-email-dp@opensource.wolfsonmicro.com>
	<1350996776-17864-2-git-send-email-dp@opensource.wolfsonmicro.com>
Date: Tue, 23 Oct 2012 21:08:50 +0800
Message-ID: <CACVXFVOMb3A=9wKm+-wnsg7=dTbjJjU2gZrUPBDK=TROTx_erA@mail.gmail.com>
Subject: Re: [PATCH 1/3 v2] firmware: Convert firmware path setup from an
 array to a list
From: Ming Lei <tom.leiming@gmail.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 8:52 PM, Dimitris Papastamos
<dp@opensource.wolfsonmicro.com> wrote:
> In preparation to support dynamic listing/updating of firmware
> paths via procfs, this patch converts the firmware path configuration
> from an array to a list.

I remembered that I have questioned on dynamic listing/updating of
firmware via procfs, looks you don't reply, :-(

      http://marc.info/?l=linux-kernel&m=134988208617179&w=2

IMO, it is not a good idea to update firmware path dynamically via proc
because it may be too late to update a dynamic search path via /proc
and drivers need request firmware just after rootfs is mounted.

kernel parameter should be a good way to pass one customerized
path.

Thanks,
-- 
Ming Lei
