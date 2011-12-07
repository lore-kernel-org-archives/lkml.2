Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab1LGSet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:34:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60736 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab1LGSes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:34:48 -0500
MIME-Version: 1.0
In-Reply-To: <20111126201334.16080.85045.stgit@notabene.brown>
References: <20111126201334.16080.85045.stgit@notabene.brown>
Date: Wed, 7 Dec 2011 20:34:47 +0200
Message-ID: <CAMP44s1Nhv-ggAh3-wPXVMaLkiNm9VUo4TnsaZm-yoSpttqaOQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] fixes for twl4030-irq in mainline
From: Felipe Contreras <felipe.contreras@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 10:17 PM, NeilBrown <neilb@suse.de> wrote:
>  The recent tidying up of twl4030-irq seems to have left it broken.
> At least it doesn't work for me on my gta04 (www.gta04.org).  The
> first interrupt from the device freezes the whole system (by being
> constantly delivered)
>
> The following 4 patches make it work for me and addresses some other
> less critical issues like a typo in a comment :-)

I also hit the same issue on the N900. These patches fix the problem for me:

Tested-by: Felipe Contreras <felipe.contreras@gmail.com>

-- 
Felipe Contreras
