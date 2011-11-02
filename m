Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab1KBSvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:51:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59066 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab1KBSvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:51:09 -0400
X-Authority-Analysis: v=1.1 cv=PzmnriOiyqYdyw8suerSEFMr8oy2Ua58JL+Rk7iuDKE= c=1 sm=0 a=DJOu6W8zkUMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=9vAfK0TlEDxfm-Ea5yEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320259868.4793.46.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Restore system filter behavior
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 Nov 2011 14:51:08 -0400
In-Reply-To: <1320258167.4793.45.camel@gandalf.stny.rr.com>
References: <4EAF46CF.8040408@cn.fujitsu.com>
	 <1320258167.4793.45.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 14:22 -0400, Steven Rostedt wrote:

> The above shows how things are just ambiguous. I have no problem in
> using the top filter to set multiple events. But the top filter should
> not keep the state of what was set. Perhaps just have system event
> filters always show default text. Like:
> 
> # cat /debug/tracing/events/sched/filter
> ### global filter ###
> # Use this to set multiple event filters
> # Only affects events that have the event fields specified in the filter
> 
> 
> I'll add your patch, but are you OK with the above always printing for
> system event filters?  Just to remove the ambiguous state.


As the filter is also used to show errors, I'll only have it print the
"message" if the filter worked. If there's an error, then the error
message will display instead.

-- Steve


