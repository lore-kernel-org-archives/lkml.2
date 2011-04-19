Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1DSGvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:51:36 -0400
Received: from linux-sh.org ([111.68.239.195]:47774 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab1DSGvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:51:35 -0400
Date: Tue, 19 Apr 2011 15:51:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] [resend] s3fb: add DDC support
Message-ID: <20110419065120.GC28271@linux-sh.org>
References: <201104181214.57501.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104181214.57501.linux@rainbow-software.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 12:14:57PM +0200, Ondrej Zary wrote:
> Add I2C support for the DDC bus and also default mode initialization by
> reading monitor EDID to the s3fb driver.
> 
> Tested on Trio64V+ (2 cards), Trio64V2/DX, Virge (3 cards),
> Virge/DX (3 cards), Virge/GX2, Trio3D/2X (4 cards), Trio3D.
> 
> Will probably not work on Trio32 - my 2 cards have DDC support in BIOS that
> looks different from the other cards but the DDC pins on the VGA connector
> are not connected.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
Applied, thanks.
