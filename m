Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0KXIqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:46:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:45710 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab0KXIqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:46:14 -0500
Subject: RE: [PATCH v1] ppc44x:PHY fixup for USB on canyonlands board
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rupjyoti Sarmah <rsarmah@apm.com>
Cc: Stefan Roese <sr@denx.de>, linuxppc-dev@lists.ozlabs.org,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <602c780cd2a81ee32f834a82814fe77f@mail.gmail.com>
References: <201011231256.oANCur3N016433@amcc.com>
	 <201011231421.02377.sr@denx.de>
	 <602c780cd2a81ee32f834a82814fe77f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 18:32:46 +1100
Message-ID: <1290583966.32570.90.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 10:25 +0530, Rupjyoti Sarmah wrote:
> 
> So, do you suggest to move this macro to the canyonlands.c ? Or
> introduce
> canyonlands.h ?

Just move it to the .c file.

Cheers,
Ben.


