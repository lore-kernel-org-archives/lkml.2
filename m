Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab2DGLiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 07:38:55 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:59732 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753727Ab2DGLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 07:38:53 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] kyrofb: fix on x86_64
Date: Sat, 7 Apr 2012 13:38:27 +0200
User-Agent: KMail/1.9.10
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201203212336.55396.linux@rainbow-software.org> <20120322000104.GB26543@linux-sh.org>
In-Reply-To: <20120322000104.GB26543@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201204071338.30521.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2012 01:01:05 Paul Mundt wrote:
> On Wed, Mar 21, 2012 at 11:36:50PM +0100, Ondrej Zary wrote:
> > kyrofb is completely broken on x86_64 because the registers are defined
> > as unsigned long. Change them to u32 to make the driver work.
> > Tested with Hercules 3D Prophet 4000XT.
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> Looks fine to me.
>
> Acked-by: Paul Mundt <lethal@linux-sh.org>

When will this go in?

-- 
Ondrej Zary
