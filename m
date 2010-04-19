Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab0DSVcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:32:33 -0400
Received: from mail-va3.bigfish.com ([216.32.180.113]:45051 "EHLO
	mail116-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750715Ab0DSVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:32:32 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zz1432P98dN936eM9371Pzz1202hz4fhzz2fh62h)
X-Spam-TCS-SCL: 1:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <4BCCCBE9.5030601@am.sony.com>
Date: Mon, 19 Apr 2010 14:32:25 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Bird, Tim" <Timothy.Bird@am.sony.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: request to add trace off and trace on with events
References: <1271707444.10448.12.camel@gandalf.stny.rr.com>	 <4BCCBF6D.3030105@am.sony.com>	 <1271709846.10448.29.camel@gandalf.stny.rr.com>	 <4BCCC392.3090509@am.sony.com> <1271711427.10448.69.camel@gandalf.stny.rr.com>
In-Reply-To: <1271711427.10448.69.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 02:10 PM, Steven Rostedt wrote:
> On Mon, 2010-04-19 at 13:56 -0700, Tim Bird wrote:
> Try:
> 
> echo 'try_to_wake_up:traceon:5' 'schedule:traceoff:5' > set_ftrace_filter
> 
> ;-)

Awesome!  I need to keep up better with the state of the art.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Network Entertainment
=============================

