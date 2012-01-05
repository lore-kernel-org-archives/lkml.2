Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab2AELRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:17:55 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:51529 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab2AELRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:17:54 -0500
Message-ID: <1325762266.1807.9.camel@x61.thuisdomein>
Subject: Re: [PATCH 2/2] time: remove the unnecessary
 CONFIG_GENERIC_CLOCKEVENS check
From: Paul Bolle <pebolle@tiscali.nl>
To: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 12:17:46 +0100
In-Reply-To: <1325770085-5162-2-git-send-email-feng.tang@intel.com>
References: <1325770085-5162-1-git-send-email-feng.tang@intel.com>
	 <1325770085-5162-2-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 21:28 +0800, Feng Tang wrote:
> In kernel/time/Kconfig:
> config GENERIC_CLOCKEVENTS_BUILD
> 	bool
> 	default y
> 	depends on GENERIC_CLOCKEVENTS
> 
> So there is no need to check CONFIG_GENERIC_CLOCKEVENTS if the
> CONFIG_GENERIC_CLOCKEVENTS_BUILD is defined already.

This is only true because nothing selects GENERIC_CLOCKEVENTS_BUILD
directly, isn't it? So if we're being strict the patch explanation
should mention that.

(Maybe it's even better to simply state
    There is no need to check CONFIG_GENERIC_CLOCKEVENTS if
    CONFIG_GENERIC_CLOCKEVENTS_BUILD is defined.

    This prepares [...]

as that would tell us just enough.)

> This prepares for the total removal of GENERIC_CLOCKEVENTS_BUILD.


Paul Bolle

