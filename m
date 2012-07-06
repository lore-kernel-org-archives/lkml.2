Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab2GFQth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:49:37 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42458 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab2GFQtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:49:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120706144846.GA13505@localhost>
References: <20120706144622.GA13387@localhost>
	<20120706144846.GA13505@localhost>
Date: Fri, 6 Jul 2012 17:49:35 +0100
Message-ID: <CAPM=9txA0OAm=8ROHXBpXZ+-onqJx41yK4_-v1go8e8W6ROVzw@mail.gmail.com>
Subject: Re: general protection fault on ttm_init()
From: Dave Airlie <airlied@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 3:48 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> ... The missed kconfig.
>
> On Fri, Jul 06, 2012 at 10:46:22PM +0800, Fengguang Wu wrote:
>> Hi Thomas,

Wierd, I'm sorta tempted to just depend drm on CONFIG_PROC_FS, but it
looks like the error path is failing to dtrt.

Dave.
