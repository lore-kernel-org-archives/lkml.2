Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935844Ab1JFLgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 07:36:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42227 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935288Ab1JFLgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 07:36:22 -0400
MIME-Version: 1.0
Date: Thu, 6 Oct 2011 13:36:21 +0200
Message-ID: <CAKfTPtB3sLWq5fHOTrFg6vfHSKnz2i17oYx9Btr0u_tWV2bsjQ@mail.gmail.com>
Subject: sched: ARM: arch_scale_freq_power
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I work to link the cpu_power of ARM cores to their frequency by using
arch_scale_freq_power. It's explained in the kernel that cpu_power is
used to distribute load on cpus and a cpu with more cpu_power will
pick up more load. The default value is SCHED_POWER_SCALE and I
increase the value if I want a cpu to have more load than another one.
Is there an advised range for cpu_power value as well as some time
scale constraints for updating the cpu_power value ?
I'm also wondering why this scheduler feature is currently disable by default ?

Regards,
Vincent
