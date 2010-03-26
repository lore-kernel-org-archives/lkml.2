Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0CZDNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:13:52 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34716 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab0CZDNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:13:50 -0400
Date: Fri, 26 Mar 2010 12:12:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-doc@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <damm@igel.co.jp>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] USB gadget r8a66597-udc.c: duplicated include
Message-ID: <20100326031235.GB5815@linux-sh.org>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net> <1269537767-7553-10-git-send-email-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269537767-7553-10-git-send-email-andrea.gelmini@gelma.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 06:22:40PM +0100, Andrea Gelmini wrote:
> drivers/usb/gadget/r8a66597-udc.c: linux/err.h is included more than once.
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>

It seems the same fix was done in two different trees and merged at
different times, resulting in the duplication now.

Applied, thanks.
