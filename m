Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0ELKuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:50:54 -0400
Received: from mx1.sophos.com ([195.166.81.52]:39622 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab0ELKuu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:50:50 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.2 kmalloc-8 slab leaks ~512 objects per second
Date: Wed, 12 May 2010 11:50:41 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33.3; KDE/4.3.5; x86_64; ; )
CC: "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       David Airlie <airlied@linux.ie>
References: <11758_1273660249_4BEA8359_11758_1675_1_201005121121.49135.tvrtko.ursulin@sophos.com> <201005121138.05254.tvrtko.ursulin@sophos.com>
In-Reply-To: <201005121138.05254.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Message-ID: <201005121150.42462.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 12/05/2010 11:50:47,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 12/05/2010 11:50:48,
	Serialize complete at 12/05/2010 11:50:48
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 May 2010 11:38:05 Tvrtko Ursulin wrote:

[snip]
> I think it is DRM (radeon) related, leak stopped when I closed all X
>  programs. I am compiling 2.6.33.3 right now and will soon reboot into it.

Leak is still present in 2.6.33.3 - the more GUI activity the more it leaks.
So the ~512 objects per second was with xosview running, but moving windows or
browsing through menus can leak a lot more (per second).

Is version of userspace drm library interesting? It is 2.4.20
(libdrm-2.4.20-12.1.x86_64).

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
