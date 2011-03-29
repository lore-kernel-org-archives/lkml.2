Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1C2TWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:22:49 -0400
Received: from fifo99.com ([67.223.236.141]:50541 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1C2TWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:22:48 -0400
Subject: Re: [PATCH] msm: watchdog: support watchdog on 8x60 and 8960
From: Daniel Walker <dwalker@fifo99.com>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
In-Reply-To: <1301105894-22835-1-git-send-email-johlstei@codeaurora.org>
References: <1301105894-22835-1-git-send-email-johlstei@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 12:22:40 -0700
Message-ID: <1301426560.4049.0.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 19:18 -0700, Jeff Ohlstein wrote:
> The msm watchdog driver is present in kernel only. It does not use the
> built-in Linux watchdog api. This is because the primary function of
> our watchdog is detecting bus lockups and interrupts being turned off
> for long periods of time. We wanted this functionality to be present
> regardless of the userspace the kernel is running beneath. Userspace
> is
> free to have its own watchdog implemented in software. 

Are you saying this is mostly a debugging facility ? The interrupts off
thing I can see as just debugging, but I don't understand the bus
lockups part.

Daniel

