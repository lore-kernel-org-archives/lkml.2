Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2BOHW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 02:22:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57986 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab2BOHWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 02:22:24 -0500
MIME-Version: 1.0
In-Reply-To: <1329284944-17943-1-git-send-email-qiang.liu@freescale.com>
References: <1329284944-17943-1-git-send-email-qiang.liu@freescale.com>
Date: Wed, 15 Feb 2012 15:22:22 +0800
X-Google-Sender-Auth: Uwr3QqopNi7ozson5JYkYLa-5ZY
Message-ID: <CADRPPNQ8LUr13J4k8fsBYSSxXVuxFdEvKyL4abxZpY32Meh=uQ@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND] fsl-sata: I/O load balancing
From: Li Yang <leoli@freescale.com>
To: Qiang Liu <qiang.liu@freescale.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 1:49 PM, Qiang Liu <qiang.liu@freescale.com> wrote:

Hi Liu Qiang,

The patch is fine except for the title and comment.  It's too vague to
say I/O load balancing.  You need explicit description like "add
interrupt coalescing support" as title.

> Reduce interrupt signals through reset Interrupt Coalescing Control Reg.
> Provide dynamic method to adjust interrupt signals and timer ticks by sysfs.
> It is a tradeoff for different applications.

How about:

Adds support for interrupt coalescing feature to reduce interrupt
events.  Provides mechanism of adjusting coalescing count and timeout
tick by sysfs on runtime, so that tradeoff of latency and CPU load can
be made depending on applications.

- Leo
