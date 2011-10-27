Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1J0KhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 06:37:23 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:57814 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1J0KhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 06:37:21 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjjYQEZvOfA==
X-RZG-CLASS-ID: mo00
Date: Thu, 27 Oct 2011 12:37:14 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        dmitry.torokhov@gmail.com, jkosina@suse.cz
Subject: Re: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
Message-ID: <20111027103714.GA13732@aepfle.de>
References: <1319645321-9770-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1319645321-9770-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, K. Y. Srinivasan wrote:

> +static struct  hv_driver mousevsc_drv = {
> +	.name = "mousevsc",

This should be KBUILD_MODNAME.

Olaf
