Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab0C2Nkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:40:41 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51756 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0C2Nkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:40:39 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com
Subject: Re: [PATCH 02/10] x86: fix out of order of gsi - full
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
	<1269221770-9667-3-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.00.1003221131470.3147@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 29 Mar 2010 06:40:28 -0700
In-Reply-To: <alpine.LFD.2.00.1003221131470.3147@localhost.localdomain> (Thomas Gleixner's message of "Mon\, 22 Mar 2010 12\:14\:15 +0100 \(CET\)")
Message-ID: <m1iq8f1c1f.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tglx@linutronix.de, len.brown@intel.com, suresh.b.siddha@intel.com, trenn@suse.de, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have played with this a bit and I have a cleaner patchset that
addresses this issue.  I plan to sleep on it, and then go through it
again before I send it.

Thomas is the procedure for working on this stuff write clean patches
and send them, and they will land in an x86 topic branch?

Eric
