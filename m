Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab2HHFup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:50:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59389 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2HHFuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120713130405.GS13885@arachsys.com>
References: <20120713130405.GS13885@arachsys.com>
Date: Wed, 8 Aug 2012 13:50:42 +0800
Message-ID: <CANE52KgHpmR7qCUUf3ZiMeskCitcAiMzzdARzy3a4RpKb73_Gg@mail.gmail.com>
Subject: Re: [PATCH] bnx2: update bnx2-mips-09 firmware to bnx2-mips-09-6.2.1b
From: Jike Song <albcamus@gmail.com>
To: Chris Webb <chris@arachsys.com>
Cc: Michael Chan <mchan@broadcom.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 9:04 PM, Chris Webb <chris@arachsys.com> wrote:
> Commit c2c20ef43d00 "bnx2: Update driver to use new mips firmware"
> updated the bnx2 driver to use bnx2-mips-09-6.2.1b in place of
> bnx2-mips-09-6.2.1a, but didn't replace the copy of bnx2-mips-09-6.2.1a
> in firmware/bnx2/ with the new version.
>
> This means that the bnx2 driver stopped working altogether for users who
> use CONFIG_FIRMWARE_IN_KERNEL to compile firmware together with drivers
> into their kernel, rather than having a runtime firmware loader.
>

Still not fixed in mainline? I encountered the same problem with
v3.6-rc1-133-g42a579a.
