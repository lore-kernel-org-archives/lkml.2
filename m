Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1FGSnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:43:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44574 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab1FGSnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:43:42 -0400
Message-ID: <4DEE712F.3080800@zytor.com>
Date: Tue, 07 Jun 2011 11:42:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 1/2] stop_machine: enable __stop_machine() to be called
 from the cpu online path
References: <20110606231655.824641917@sbsiddha-MOBL3.sc.intel.com>	 <20110606231752.023885847@sbsiddha-MOBL3.sc.intel.com>	 <20110607180244.GA27552@elte.hu> <1307471902.21608.4476.camel@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <1307471902.21608.4476.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 11:38 AM, Suresh Siddha wrote:
> 
> This is kind of a false positive. We are just checking if the calling
> cpu is online/offline (and there is no possible process migration
> between an online and offline cpu).
> 

Is the state not available in a percpu variable of some sort?  If not,
shouldn't it be rather than indirecting via a CPU number?

	-hpa
