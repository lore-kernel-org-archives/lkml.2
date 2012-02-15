Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2BOHv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 02:51:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33212 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab2BOHvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 02:51:24 -0500
MIME-Version: 1.0
In-Reply-To: <1329291634-883-1-git-send-email-qiang.liu@freescale.com>
References: <1329291634-883-1-git-send-email-qiang.liu@freescale.com>
Date: Wed, 15 Feb 2012 15:51:23 +0800
X-Google-Sender-Auth: iSrS8fHT9POLm3NQ4hmoJeGJnkA
Message-ID: <CADRPPNTmRvPVymJmW4vagU+2M4DmqeDSEj=4=R_=YDJekOTccQ@mail.gmail.com>
Subject: Re: [PATCH V3] fsl-sata: add support for interrupt coalsecing feature
From: Li Yang <leoli@freescale.com>
To: Qiang Liu <qiang.liu@freescale.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 3:40 PM, Qiang Liu <qiang.liu@freescale.com> wrote:
> Adds support for interrupt coalescing feature to reduce interrupt events.
> Provides a mechanism of adjusting coalescing count and timeout tick by sysfs
> at runtime, so that tradeoff of latency and CPU load can be made depending
> on different applications.
>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>

Acked-by: Li Yang <leoli@freescale.com>

- Leo
