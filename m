Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2GDNIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:08:30 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:45536 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2GDNI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:08:27 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnRKABc/9E9V5qg+PGdsb2JhbABEihmtBhkBAQEBHgMWDSeCGAEBBTocIxAIAw4KLhQlChoThhGBfrs6FIslhVdgA5U2hWaMf4Fd
X-IronPort-AV: E=Sophos;i="4.77,524,1336341600"; 
   d="scan'208";a="370997357"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 4 Jul 2012 15:08:48 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Input: synaptics - add sysfs access to firmware
 ID & board ID
Message-ID: <20120704130848.GA316@polaris.bitmath.org>
References: <1341392837-19115-1-git-send-email-djkurtz@chromium.org>
 <1341392837-19115-2-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341392837-19115-2-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 05:07:17PM +0800, Daniel Kurtz wrote:
> Allow userspace to query firmware ID and board ID, which are read and
> cached during device initialization.
> 
> This information can be read, for instance, by a userspace feedback
> reporting tool, to include this information in its reports.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/mouse/synaptics.c |   41 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 41 insertions(+), 0 deletions(-)

Still reluctant here, but I am fine with whatever Dmitry thinks about it.

Thanks.
Henrik
