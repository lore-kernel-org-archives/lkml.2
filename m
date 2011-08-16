Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1HPFUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:20:21 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:40611 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1HPFUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:20:20 -0400
Date: Tue, 16 Aug 2011 08:19:18 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Erik Gilling <konkers@android.com>, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: tegra: Add missing include of linux/erron.h and
 linux/types.h
Message-ID: <20110816051918.GA19435@sapphire.tkos.co.il>
References: <1313471744.5824.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313471744.5824.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Aug 16, 2011 at 01:15:44PM +0800, Axel Lin wrote:
> Include linux/erron.h to fix below build error.

s/erron/errno/ here, and in the subject.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
