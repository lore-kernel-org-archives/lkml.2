Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2IJDAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:00:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55371 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2IJDAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:00:22 -0400
MIME-Version: 1.0
In-Reply-To: <1343843371-14143-5-git-send-email-matt@genesi-usa.com>
References: <1343843371-14143-1-git-send-email-matt@genesi-usa.com>
	<1343843371-14143-5-git-send-email-matt@genesi-usa.com>
Date: Mon, 10 Sep 2012 00:00:21 -0300
Message-ID: <CAOMZO5CcUZ8NKM6uHkBB1Yo9MjeoBq9NzpOYwT1squM4TOgV7g@mail.gmail.com>
Subject: Re: [PATCH 4/4] efikamx: remove Efika MX-specific CHRGVBUS hack from
 the USB driver
From: Fabio Estevam <festevam@gmail.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 2:49 PM, Matt Sealey <matt@genesi-usa.com> wrote:
> Since we're removing Efika MX support from the tree (for now), remove
> the hack present in the USB host driver since it will never run and
> isn't useful on any other systems.
>
> Signed-off-by: Matt Sealey <matt@genesi-usa.com>

You should Cc linux-usb list and the USB maintainer on this one.

Regards,

Fabio Estevam
