Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab1GRI3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:29:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63801 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab1GRI3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <1310951766-3840-3-git-send-email-akinobu.mita@gmail.com>
References: <1310951766-3840-1-git-send-email-akinobu.mita@gmail.com>
	<1310951766-3840-3-git-send-email-akinobu.mita@gmail.com>
Date: Mon, 18 Jul 2011 16:29:11 +0800
Message-ID: <CAM_iQpW_NGMB0dCNRLS_OaWwL=A974jEdhW0++tiiJCK24+Wfg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] cpu: CPU notifier error injection
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 9:16 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
...
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 72e2384..cf0b4b7 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -583,3 +583,11 @@ Why:       Superseded by the UVCIOC_CTRL_QUERY ioctl.
>  Who:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
>  ----------------------------
> +
> +What:  Support for CPU_NOTIFIER_ERROR_INJECT (cpu-notifier-error-inject.ko)
> +When:  3.3
> +Why:   Replaced with more generic debugfs interface in
> +       /sys/kernel/debug/cpu-notifier-error-inject/
> +Who:   Akinobu Mita <akinobu.mita@gmail.com>

Hi, Akinobu,

I think it is okay to just remove it by this patchset, no need to defer it.
