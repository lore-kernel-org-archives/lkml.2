Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1GAAzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:55:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61740 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab1GAAzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:55:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110630213728.GA30291@marc.osknowledge.org>
References: <20110630213728.GA30291@marc.osknowledge.org>
Date: Fri, 1 Jul 2011 08:55:23 +0800
Message-ID: <BANLkTimk_yCCy+4hL6949nxPs5Qo4y1Qow@mail.gmail.com>
Subject: Re: CONFIG_ACPI_PROCFS_POWER to be removed in 2.6.39
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Marc Koschewski <marc@osknowledge.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 5:37 AM, Marc Koschewski <marc@osknowledge.org> wrote:
> Hey guys,
>
> CONFIG_ACPI_PROCFS_POWER is still there. Missed it or did you want it
> to reside?

There was a patch to remove it,

https://patchwork.kernel.org/patch/654021/

Don't know why it is not merged.
