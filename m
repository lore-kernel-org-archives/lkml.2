Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab1FARAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:00:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51399 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab1FARAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=otTydPVSSge4X4RPr279iPjuC8gex/ObSJDnJzzqIiMvQE3szWiAeTkBIL8E/0oDxN
         WshBkkNurbbiRrDrkQBLPLiRLmLLqlL9D7sxpAESGbkyYBylRS7LawMEH5djpouT4AmP
         ntZ5L0Fp0GJ9jVdfumAFPATnHHEKY5plOReQA=
MIME-Version: 1.0
In-Reply-To: <1306945763-6583-1-git-send-email-wanlong.gao@gmail.com>
References: <1306945763-6583-1-git-send-email-wanlong.gao@gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 1 Jun 2011 13:00:28 -0400
X-Google-Sender-Auth: EdDBFDhUtmES1ioY6e6-8QVrqfY
Message-ID: <BANLkTinEc8OLHnkVCZVpHK4ZnC1DHbEsvw@mail.gmail.com>
Subject: Re: [PATCH] Fix build warning of the defconfigs
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux@arm.linux.org.uk, hans-christian.egtvedt@atmel.com,
        ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
        lethal@linux-sh.org, gxt@mprc.pku.edu.cn, david.woodhouse@intel.com,
        akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de,
        mingo@elte.hu, rientjes@google.com, w.sang@pengutronix.de,
        sam@ravnborg.org, manuel.lauss@googlemail.com, anton@samba.org,
        arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 12:29, Wanlong Gao wrote:
>  arch/blackfin/configs/CM-BF548_defconfig   |    2 +-

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
