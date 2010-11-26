Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0KZN30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:29:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0KZN30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:29:26 -0500
Date: Fri, 26 Nov 2010 08:29:22 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Takashi Iwai <tiwai@suse.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: patch_realtek: handle unset external amp bits
Message-ID: <20101126132922.GO22651@bombadil.infradead.org>
References: <20101125185730.GK22651@bombadil.infradead.org>
 <s5h8w0gskds.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8w0gskds.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 06:51:11AM +0100, Takashi Iwai wrote:
> How about setting default to ALC_INIT_DEFAULT instead like the patch
> below?  This is safer than forcing ALC_INIT_DEFAULT to all, I
> suppose.
> 

As I understand the code, that should work fine. I'll build a new kernel
for my tester to confirm, I suspect it will though. :)

Thanks!
--Kyle
