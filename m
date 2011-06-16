Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab1FPJB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:01:57 -0400
Received: from solo.fdn.fr ([80.67.169.19]:33264 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab1FPJBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:01:40 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jun 2011 05:01:40 EDT
Date: Thu, 16 Jun 2011 10:55:47 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: [RFC] Add Arm cpu topology definition
Message-ID: <20110616085547.GH4935@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linaro-dev@lists.linaro.org
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Vincent Guittot, le Thu 16 Jun 2011 10:49:13 +0200, a écrit :
> The affinity between Arm processors is defined in the MPIDR register.
> We can identify which processors are in the same cluster,
> and which ones have performance interdependency. The cpu topology
>  of an Arm platform can be set thanks to this register and this topology
> is then used by sched_mc and sched_smt.

Cool!  Could you check that the hwloc tool gets also gets this
information from userland through /sys, and/or send me the output of the
hwloc-gather-topology tool from hwloc so we can add an testcase for
this?

Samuel
