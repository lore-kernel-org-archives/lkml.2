Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab0J1DAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 23:00:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54591 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096Ab0J1DAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 23:00:16 -0400
Message-ID: <4CC8E6F7.5080405@zytor.com>
Date: Wed, 27 Oct 2010 19:59:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        ddaney@caviumnetworks.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] move arch_init_ideal_nop5 later
References: <cover.1288212485.git.jbaron@redhat.com>	 <2de96f2012e81597079ab0b09a1487e7061b9cc6.1288212486.git.jbaron@redhat.com>	 <e35a5b13-ea12-42d2-b569-ff1d69ef58d1@email.android.com> <1288231897.18238.133.camel@gandalf.stny.rr.com>
In-Reply-To: <1288231897.18238.133.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 07:11 PM, Steven Rostedt wrote:
> On Wed, 2010-10-27 at 15:24 -0700, H. Peter Anvin wrote:
>> The exception test is broken anyway for reasons I already explained, so it would be better to just drop it.
> 
> Would you be OK if we nuke it for the next merge window? It's been in
> there since 2.6.28, I'd hate to drop it now to discover that it breaks
> something this late in the merge window.
> 

I'd be much happier nuking it now than moving the invocation.  The
latter is much more likely to break things.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

