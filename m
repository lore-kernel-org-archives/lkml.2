Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2HYMUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 08:20:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58389 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab2HYMUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 08:20:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ7jCmkhetET-NpSOPtphKs9Mq-FTXZQK2Di=RMHo+6Zcewn9w@mail.gmail.com>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208242035.38733.tweek@tweek.dk>
	<CAJ7jCmmuxiWegxkdAsbtCbv-zXgmt--V2bVdENkupGTwj=3HSg@mail.gmail.com>
	<201208242153.24638.tweek@tweek.dk>
	<CAJ7jCmkhetET-NpSOPtphKs9Mq-FTXZQK2Di=RMHo+6Zcewn9w@mail.gmail.com>
Date: Sat, 25 Aug 2012 14:20:05 +0200
Message-ID: <CAJ7jCmnLm4t_w98A=zjz2M32xvR2NyGfDH+kFstp4ZEquZ_=VA@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: wbrana <wbrana@gmail.com>
To: Martin Nybo Andersen <tweek@tweek.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/25/12, wbrana <wbrana@gmail.com> wrote:
> Open source drivers are black listed by Chromium because of instability
> file software_rendering_list.json:
> NVIDIA cards with nouveau drivers in Linux are crash-prone
> The Intel Mobile 945 Express family of chipsets is not compatible with
> WebGL
> Intel mesa drivers are crash-prone
> ATI/AMD cards with third-party drivers in Linux are crash-prone
> Drivers are unreliable for Optimus on Linux
There is chance Ivy Bridge can accelerate Chromium, but it can't
accelerate open source game at sufficient frame rate - 60 fps
http://www.phoronix.com/scan.php?page=article&item=intel_ivy_gpushow&num=8
