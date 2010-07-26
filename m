Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0GZEyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 00:54:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46416
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045Ab0GZEyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 00:54:22 -0400
Date: Sun, 25 Jul 2010 21:54:38 -0700 (PDT)
Message-Id: <20100725.215438.189694767.davem@davemloft.net>
To: mditto@google.com
Cc: netdev@vger.kernel.org, adobriyan@gmail.com, shemminger@vyatta.com,
        ben@decadent.org.uk, stas@lvk.cs.msu.su, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] forcedeth: Fix different hardware statistics versions.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100722220252.E46C7182B00@starthinker.mtv.corp.google.com>
References: <20100722220252.E46C7182B00@starthinker.mtv.corp.google.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mditto@google.com (Mike Ditto)
Date: Thu, 22 Jul 2010 15:02:52 -0700 (PDT)

> The macros for the values of the bit field describing the four
> different versions of statistics supported by different hardware
> variants were being misused.  Where the code was trying to test if the
> hardware implements V3, it was actually testing whether it implements
> any of V1, V2, or V3, causing the driver to report statistics that
> don't really exist in the hardware, with bogus values.
> 
> Signed-off-by: Mike Ditto <mditto@google.com>

Applied to net-next-2.6, thanks.
