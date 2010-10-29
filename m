Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985Ab0J2UwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:52:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59524 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758342Ab0J2UwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:52:14 -0400
Message-ID: <4CCB33C6.6040806@zytor.com>
Date: Fri, 29 Oct 2010 13:51:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        rth@redhat.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
References: <cover.1288212485.git.jbaron@redhat.com>	 <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>	 <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>	 <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com>	 <20101028201112.GA4792@redhat.com> <20101029063450.GE29463@elte.hu>	 <1288354687.18238.433.camel@gandalf.stny.rr.com>	 <20101029122230.GA25663@elte.hu>	 <1288356418.18238.454.camel@gandalf.stny.rr.com>	 <20101029133524.GA23916@Krystal>	 <1288369108.29632.1.camel@gandalf.stny.rr.com>	 <4CCB01D1.2050004@caviumnetworks.com>	 <1288373582.29632.3.camel@gandalf.stny.rr.com> <4CCB2B7B.6020002@zytor.com> <1288385260.29632.24.camel@gandalf.stny.rr.com>
In-Reply-To: <1288385260.29632.24.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2010 01:47 PM, Steven Rostedt wrote:
> 
> Fine, but we can wait till 2.6.38 for that. For now we have a manual
> config option. I'm not changing it until I have 4.5.2 in my distcc farm
> and testing it out.
> 
> If things turn out fine, we can have > 4.5.2 || run check option. Or
> just stick with 4.5.2. But we can debate this later (or at KS if you
> want ;-)
> 

KS would be a good place to talk about toolchain dependencies in
general.  It's a big problem.

	-hpa
