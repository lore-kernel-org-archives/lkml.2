Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab0FOR3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:29:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45252 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab0FOR3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:29:00 -0400
Message-ID: <4C17B823.5070008@zytor.com>
Date: Tue, 15 Jun 2010 10:28:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jbaron@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 00/13] jump label v9
References: <cover.1276116186.git.jbaron@redhat.com>	<20100614.204759.226765762.davem@davemloft.net>	<20100615142811.GB2750@redhat.com> <20100615.101306.260078767.davem@davemloft.net>
In-Reply-To: <20100615.101306.260078767.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:13 AM, David Miller wrote:
> From: Jason Baron <jbaron@redhat.com>
> Date: Tue, 15 Jun 2010 10:28:11 -0400
> 
>> For example, the reason I have it in the code is b/c x86 determines
>> the best no-op at run-time. Are other architectures going to have to
>> require this kind of functionality. Or like sparc, are we going to
>> be able to generally hard-code the nops on non-x86 at compile-time?
> 
> I think most architectures will use a constant nop sequence, in fact
> x86 is the only one I can think of that needs variable nop sequences.
> 

One could potentially see that for other variable-length-instructions
architectures, e.g. S390, m68k or ARM/Thumb2 as well.

For fixed-length-instructions architectures, well, it shouldn't be an issue.

	-hpa
