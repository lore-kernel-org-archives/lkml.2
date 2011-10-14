Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab1JNTra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:47:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53671 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756045Ab1JNTr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:47:29 -0400
Date: Fri, 14 Oct 2011 20:47:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] regulator: Fix possible nullpointer dereference
 in regulator_enable()
Message-ID: <20111014194726.GQ2931@opensource.wolfsonmicro.com>
References: <201110141800.29440.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201110141800.29440.heiko@sntech.de>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 06:00:29PM +0200, Heiko Stübner wrote:
> In the case where _regulator_enable returns an error it was not checked
> if a supplying regulator exists before trying to disable it, leading
> to a null pointer-dereference if no supplying regulator existed.

Applied, thanks.
