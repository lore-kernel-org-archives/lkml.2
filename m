Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161205Ab2GLPgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:36:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54221 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947Ab2GLPga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:36:30 -0400
Date: Thu, 12 Jul 2012 08:36:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: Remove CONFIG_EXTCON_MODULE config to fix build
 break
Message-ID: <20120712153626.GD17365@kroah.com>
References: <1342067547-6276-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342067547-6276-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 01:32:27PM +0900, Chanwoo Choi wrote:
> This patch modify 'Kconfig' of EXTCON Subsystem to support either
> active or inactive of EXTCON Subsystem. The various subsystem refer
> to EXTCON subsystem for controlling external connector, so core class
> of EXTCON should be included in kernel image. If EXTCON subsystem is
> builded with MODULE, other subsystem have build break because of
> linking the core class of EXTCON.

Then something else is wrong, as the extcon_class code should be able to
be built as a module.  Don't load up systems with kernel code that they
don't need (think of distro kernels that have to build everything.)

So no, please fix the real problem here, I will not take this patch,
sorry.

greg k-h
