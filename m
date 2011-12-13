Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1LMVAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 16:00:11 -0500
Received: from lo.gmane.org ([80.91.229.12]:45002 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1LMVAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 16:00:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: batouzo <batouzo@gmx.com>
Subject: Re: [3.1.4] mm slub memory corruption in drm_vblank_cleanup
Date: Tue, 13 Dec 2011 21:59:50 +0100
Message-ID: <jc8ec6$m42$1@dough.gmane.org>
References: <jc7q4e$qv9$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: ip-1-141.gemini.net.pl
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
In-Reply-To: <jc7q4e$qv9$1@dough.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 04:14 PM, batouzo wrote:

Should I write to soem other group and/or email developers as well?

Can anyone help debug this bug?

> Allocated in drm_vblank_init+0x139/0x260 [drm] + Freed in
> drm_vblank_cleanup+0x78/0x90 [drm]
> Allocated in drm_vblank_init+0xbe/0x260 [drm] + Freed in
> drm_vblank_cleanup+0x48/0x90 [drm]


