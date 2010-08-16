Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0HPWCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 18:02:33 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:42428 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751956Ab0HPWCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 18:02:32 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] [RFC] cyber2000fb: avoid palette corruption at higher clocks
Date: Tue, 17 Aug 2010 00:02:18 +0200
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201008162209.56902.linux@rainbow-software.org> <20100816210634.GB10119@n2100.arm.linux.org.uk>
In-Reply-To: <20100816210634.GB10119@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008170002.21501.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 August 2010 23:06:34 Russell King - ARM Linux wrote:
> On Mon, Aug 16, 2010 at 10:09:54PM +0200, Ondrej Zary wrote:
> > When 1280x1024@75Hz mode is set, console palette is not set properly -
> > sometimes the background is white, sometimes yellow and text colors are
> > also messed up. This does not happen at 1280x1024@60Hz and below.
>
> I'm not going to have much time to look at your patches, and I
> definitely want to test them on the NetWinder to make sure we
> don't regress the primary platform that this driver is supporting.
>
> I should have more time to look at them in September.

Thanks, I'll put the cards to sleep and take them out later.

-- 
Ondrej Zary
