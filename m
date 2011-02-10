Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab1BJXG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:06:29 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38739 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794Ab1BJXG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:06:28 -0500
Subject: Re: [PATCH 1/4] RTC: Include information about UIE and PIE in RTC
 driver proc.
From: John Stultz <john.stultz@linaro.org>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, a.zummo@towertech.it
In-Reply-To: <1297113368-27174-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
	 <1297113368-27174-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 10 Feb 2011 15:06:13 -0800
Message-ID: <1297379173.1865.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 19:16 -0200, Marcelo Roberto Jimenez wrote:
> Generic RTC code is always able to provide the necessary information
> about update and periodic interrupts. This patch add such information to
> the proc interface.

This seems to be mostly formatting changes. Are you sure we wont' break
applications expecting the existing format?

thanks
-john


