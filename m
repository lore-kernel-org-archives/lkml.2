Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910Ab2C2SUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:20:51 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:20651
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759229Ab2C2SUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:20:44 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzzz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F74A7E1.3010500@am.sony.com>
Date: Thu, 29 Mar 2012 11:20:17 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.28) Gecko/20120306 Thunderbird/3.1.20
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
References: <20120328210631.GB2297@fifo99.com> <20120329145055.GE13912@fifo99.com> <4F748CF6.4010205@am.sony.com> <20120329175209.GE16476@fifo99.com>
In-Reply-To: <20120329175209.GE16476@fifo99.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/2012 10:52 AM, Daniel Walker wrote:
> On Thu, Mar 29, 2012 at 09:25:26AM -0700, Tim Bird wrote:
>> At the moment, I'm not considering an alternative for logger that runs
>> completely in user-space.  Having said that, this test is certainly interesting,
>> and may provide some performance numbers for logger or alternatives that would
>> be useful to compare.
>
> I was just thinking what does an accurate PID actually get you? If you
> looking at some logs with a PID of 20048, does that mean something to
> you? It doesn't actually mean much because you can't map that back to
> anything. If you have the device, and the process is still running then
> you could look it up ..
>
> So lets say logger was modified to record comm values.. That way you
> could record the actual process name AND the pid. Well if you use
> prctl(PR_SET_NAME), you can forge comm values. So that doesn't get you
> much either..
>
> So even if you record accurate PID values, it doesn't mean anything
> anyway.
Putting bogus pids in the log would allow a log DDOS-er to hide their
activity more easily.  But with the log in user-space, there are much more
insidious things that could be done to hide or corrupt log activity.  So
the sensitivity of this particular piece of log data is not that great.
  -- Tim


