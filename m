Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1GMBFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 21:05:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36066 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab1GMBFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 21:05:23 -0400
MIME-Version: 1.0
In-Reply-To: <1310470780-12330-1-git-send-email-mmarek@suse.cz>
References: <alpine.DEB.2.01.1107040242180.9183@trent.utfs.org>
	<1310470780-12330-1-git-send-email-mmarek@suse.cz>
Date: Wed, 13 Jul 2011 09:05:22 +0800
Message-ID: <CAM_iQpWfSFPcvDJCDwS9ADCEvw-6A3wyUh+kkhgqHOi2Zx_eSg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Do not write to builddir in modules_install
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 7:39 PM, Michal Marek <mmarek@suse.cz> wrote:
> Let depmod.sh create a temporary directory in /tmp instead of writing to
> the build directory as root. The mktemp utility should be available on
> any recent system (and there is already scripts/gen_initramfs_list.sh
> relying on it).
>

Hmm, why not use $objtree/.tmp_depmod?
