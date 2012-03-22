Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2CVAB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:01:29 -0400
Received: from linux-sh.org ([111.68.239.195]:54917 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab2CVABZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:01:25 -0400
Date: Thu, 22 Mar 2012 09:01:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kyrofb: fix on x86_64
Message-ID: <20120322000104.GB26543@linux-sh.org>
References: <201203212336.55396.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203212336.55396.linux@rainbow-software.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 11:36:50PM +0100, Ondrej Zary wrote:
> kyrofb is completely broken on x86_64 because the registers are defined as
> unsigned long. Change them to u32 to make the driver work.
> Tested with Hercules 3D Prophet 4000XT.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
Looks fine to me.

Acked-by: Paul Mundt <lethal@linux-sh.org>
