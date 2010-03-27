Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0C0W5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 18:57:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37636 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab0C0W5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 18:57:48 -0400
Date: Sat, 27 Mar 2010 22:57:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: mad_soft@inbox.ru, rpjday@crashcourse.ca, jaswinderrajput@gmail.com,
       kristoffer.ericson@gmail.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: mach-sa1100: fix checkpatch.pl issues.
Message-ID: <20100327225727.GE13203@n2100.arm.linux.org.uk>
References: <1268338225-32253-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268338225-32253-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 05:10:22PM -0300, Marcelo Roberto Jimenez wrote:
> This patch fixes checkpatch.pl issues in drivers/rtc/rtc-sa1100.c,
> which I will later mofify.

I think you want to send this (and other rtc patches) to
rtc-linux@googlegroups.com and Alessandro Zummo <a.zummo@towertech.it>
for their input.
