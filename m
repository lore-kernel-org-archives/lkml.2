Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab2GDM4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:56:41 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:58158 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2GDM4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:56:37 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnZKACA89E9V5qg+PGdsb2JhbABEihmtBRkBAQEBHgMWDSeCGAEBBTocEwEPEAgDDgouFCUKGhOID7s5FIslhVdgA5U2hWaMfw
X-IronPort-AV: E=Sophos;i="4.77,524,1336341600"; 
   d="scan'208";a="74597126"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 4 Jul 2012 14:56:59 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] Input: synaptics - print firmware ID and board
 number at init
Message-ID: <20120704125659.GA261@polaris.bitmath.org>
References: <1341392837-19115-1-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341392837-19115-1-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 05:07:16PM +0800, Daniel Kurtz wrote:
> Read the Firmware ID and Board Number from a synaptics device at init
> and display them in the system log.
> 
> Device behavior is very board and firmware dependent.
> It may prove useful for users to include this information when providing
> bug reports or other feedback.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/mouse/synaptics.c |   38 ++++++++++++++++++++++++++++++++++++--
>  drivers/input/mouse/synaptics.h |    3 +++
>  2 files changed, 39 insertions(+), 2 deletions(-)

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
