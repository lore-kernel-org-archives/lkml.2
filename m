Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2GJQXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:23:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54530 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab2GJQW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:22:57 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.176.107]
In-Reply-To: <1341936444-3094-1-git-send-email-fuga@studiofuga.com>
References: <1341936444-3094-1-git-send-email-fuga@studiofuga.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 10 Jul 2012 19:22:36 +0300
Message-ID: <CAK=Wgbaf0On3teqOw1myqkS4Dei3Vw2Zn=0xfOv-YiNUjFr0fg@mail.gmail.com>
Subject: Re: [PATCH] rpmsg bus subsys_initcall initialization ordering
To: Federico Fuga <fuga@studiofuga.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Federico,

On Tue, Jul 10, 2012 at 7:07 PM, Federico Fuga <fuga@studiofuga.com> wrote:
> omaprpc depends on the rpmsg bus.

Sorry for the ignorance, but what's omaprpc ? :)

I guess it's some out-of-tree module (which I've never seen) so I'm
not sure we want change mainline code to fix issues with it.

If your code is anyway out-of-tree, it'd probably make more sense if
this patch stays out of tree too (plus I have no way to review this
patch, and understand the issue it fixes, without seeing the relevant
code).

If this really is about mainline kernel, let me know.

Thanks,
Ohad.
