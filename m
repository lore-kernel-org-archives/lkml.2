Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0KXFae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:30:34 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:13996 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0KXFac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:30:32 -0500
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohavlCkce+Ub5QXMSOpHp3KJo5I7MB
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: Rupjyoti Sarmah <rsarmah@apm.com>
Subject: Re: [PATCH v1] ppc44x:PHY fixup for USB on canyonlands board
Date: Wed, 24 Nov 2010 06:30:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35.7-sr; KDE/4.5.3; i686; ; )
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <201011231256.oANCur3N016433@amcc.com> <201011231421.02377.sr@denx.de> <602c780cd2a81ee32f834a82814fe77f@mail.gmail.com>
In-Reply-To: <602c780cd2a81ee32f834a82814fe77f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011240630.26570.sr@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 November 2010 05:55:03 Rupjyoti Sarmah wrote:
> >> +#define BCSR_USB_EN	0x11
> >
> >This define is wrong here. Its not common for all 44x platforms but
> 
> Canyonlands specific.
> 
> So, do you suggest to move this macro to the canyonlands.c ? Or introduce
> canyonlands.h ?

canyonlands.c is fine with me.

Cheers,
Stefan
