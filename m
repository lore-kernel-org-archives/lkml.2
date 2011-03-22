Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1CVGvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 02:51:45 -0400
Received: from linux-sh.org ([111.68.239.195]:36671 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab1CVGvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 02:51:42 -0400
Date: Tue, 22 Mar 2011 15:51:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ondrej Zary <linux@rainbow-software.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] s3fb: various changes
Message-ID: <20110322065113.GD25925@linux-sh.org>
References: <201103012018.01607.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103012018.01607.linux@rainbow-software.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 08:17:59PM +0100, Ondrej Zary wrote:
> This patch set adds new hardware support, fixes some display problems and also
> improves performance of s3fb driver.
> 
> Everything was tested on various Trio32, Trio64V+, Trio64V2/DX, Virge, 
> Virge/DX, Trio3D and Trio3D/2X cards.
> 
> It assumes that David Miller's "Make SVGA oriented FBs work on multi-domain 
> PCI" patch set is applied.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
Both series are now applied.
