Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0C2R6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:58:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38219 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619Ab0C2R6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:58:45 -0400
Message-ID: <4BB0EA22.7000004@zytor.com>
Date: Mon, 29 Mar 2010 10:57:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com
Subject: Re: [PATCH 02/10] x86: fix out of order of gsi - full
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>	<1269221770-9667-3-git-send-email-yinghai@kernel.org>	<alpine.LFD.2.00.1003221131470.3147@localhost.localdomain> <m1iq8f1c1f.fsf@fess.ebiederm.org>
In-Reply-To: <m1iq8f1c1f.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 06:40 AM, Eric W. Biederman wrote:
> 
> I have played with this a bit and I have a cleaner patchset that
> addresses this issue.  I plan to sleep on it, and then go through it
> again before I send it.
> 
> Thomas is the procedure for working on this stuff write clean patches
> and send them, and they will land in an x86 topic branch?
> 

Pretty much, yes.

	-hpa
