Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030616Ab2HQHAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:00:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43756 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964833Ab2HQHAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:00:46 -0400
Date: Fri, 17 Aug 2012 09:00:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120817070042.GA24241@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
 <20120816095439.GA30794@avionic-0098.mockup.avionic-design.de>
 <20120816111044.GA12029@x1.osrc.amd.com>
 <20120816120541.GA10154@avionic-0098.adnet.avionic-design.de>
 <20120817061102.GA6003@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120817061102.GA6003@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 08:11:02AM +0200, Thierry Reding wrote:
> How about the patch below?
> 
> Thierry

> From deb6852dc5e9da365a33c744f2dc107ae11b407a Mon Sep 17 00:00:00 2001
> From: Thierry Reding <thierry.reding@avionic-design.de>
> Date: Thu, 16 Aug 2012 08:01:21 +0200
> Subject: [PATCH v2] pwm: Improve Kconfig help text
> 
> The Kconfig help text should help the user understand what functionality
> is provided by an option. This is especially true for new subsystems. An
> improved help text is provided by this commit in the hopes of clarifying
> the usefulness of the PWM framework.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Absolutely! Now even I understand it :-).

Acked-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
    Boris.
