Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab1K3Jhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:37:41 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:42116 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661Ab1K3Jhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:37:38 -0500
MIME-Version: 1.0
In-Reply-To: <1322590387-27075-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1322590387-27075-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Wed, 30 Nov 2011 09:37:37 +0000
Message-ID: <CABS+qY2R+NDgE4skyh4do1CBbOWYHd22esZoA7FLRnWxAgGRMw@mail.gmail.com>
Subject: Re: [PATCH] regulator: Allow regulators to register with no init_data
From: "Girdwood, Liam" <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 November 2011 18:13, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> This allows read-only access to the device configuration which may be
> useful for diagnostics.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Liam Girdwood <lrg@ti.com>
