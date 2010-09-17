Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0IQJyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:54:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34742 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0IQJx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:53:59 -0400
MIME-Version: 1.0
In-Reply-To: <1282222699.1236.21.camel@yio.site>
References: <1282222699.1236.21.camel@yio.site>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 17 Sep 2010 11:53:43 +0200
Message-ID: <AANLkTikpCt-RjK87qb0cwdu_uUSfR-Dn_0d5PYhETM5T@mail.gmail.com>
Subject: Re: [PATCH] uinput: add devname alias to allow module on-demand load
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 14:58, Kay Sievers <kay.sievers@vrfy.org> wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: uinput: add devname alias to allow module on-demand load
>
> Recent modprobe and udev versions allow to create device nodes
> for modules which are not loaded. Only the first access will cause
> the in-kernel module loader to pull-in the module. Systems which
> never access the device node will not needlessly load the module,
> and no longer need init scripts or other facilities to unconditionally
> load it.

Dmitry?

Kay
