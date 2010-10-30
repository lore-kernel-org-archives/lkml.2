Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab0J3Hr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 03:47:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39289 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0J3Hrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 03:47:53 -0400
Date: Sat, 30 Oct 2010 09:47:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        rth@redhat.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
Message-ID: <20101030074749.GB1721@basil.fritz.box>
References: <20101029063450.GE29463@elte.hu>
 <1288354687.18238.433.camel@gandalf.stny.rr.com>
 <20101029122230.GA25663@elte.hu>
 <1288356418.18238.454.camel@gandalf.stny.rr.com>
 <20101029133524.GA23916@Krystal>
 <1288369108.29632.1.camel@gandalf.stny.rr.com>
 <4CCB01D1.2050004@caviumnetworks.com>
 <1288373582.29632.3.camel@gandalf.stny.rr.com>
 <4CCB2B7B.6020002@zytor.com>
 <1288385260.29632.24.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288385260.29632.24.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fine, but we can wait till 2.6.38 for that. For now we have a manual
> config option. I'm not changing it until I have 4.5.2 in my distcc farm
> and testing it out.

It's probably obvious, but a manual config option still breaks
the allyes|modconfig crowd.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
