Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab2GaPQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:16:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab2GaPQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:16:04 -0400
Date: Tue, 31 Jul 2012 11:16:00 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: awful kconfig help texts.
Message-ID: <20120731151600.GA19412@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PWM Support (PWM) [N/y/?] (NEW) ?

CONFIG_PWM:

This enables PWM support through the generic PWM framework.


Well that's.. enlightening. I'm picking on PWM here, but this isn't an
isolated case.  Every merge window we see a slew of new options with useless
help texts. They may as well be non-existent. (Actually in some cases, they are).

If someone has to read the code to find out what the driver is, your help text probably sucks.


(I'll leave "why does this option even show up on x86" as a separate rant)

	Dave

