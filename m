Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0D1Vyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:54:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40461 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab0D1Vyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:54:46 -0400
Message-ID: <4BD8AE5A.3000900@zytor.com>
Date: Wed, 28 Apr 2010 14:53:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: David Miller <davem@davemloft.net>, jbaron@redhat.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com, dank@kegel.com
Subject: Re: [PATCH 00/11] jump label v7
References: <cover.1271427118.git.jbaron@redhat.com> <20100422.161700.191166551.davem@davemloft.net> <20100427.175858.134109609.davem@davemloft.net> <20100428013951.GM12389@ozlabs.org> <20100428014941.GA8389@Krystal>
In-Reply-To: <20100428014941.GA8389@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 06:49 PM, Mathieu Desnoyers wrote:
> * Tony Breeds (tony@bakeyournoodle.com) wrote:
>> On Tue, Apr 27, 2010 at 05:58:58PM -0700, David Miller wrote:
>>
>>> The kernel stops compiling after the second patch because
>>> kernel/jump_label.c is compiled unconditionally, and this generates an
>>> attempt to include asm/alternatives.h which is an x86-only phenomenon.
>>>
>>> Do you have access to a cross-compile environment or at least some
>>> non-x86 system you can test build on before submitting these patch
>>> sets?
>>
>> I heard cross-compilers?
>>
>> http://kernel.org/pub/tools/crosstool/files/bin/  i686 and x86_64 and 4.4.0
>> compilers suitable for kernel work.
>>
>> I plan to build 4.4.$latest and 4.5.0 ASAP.
>>
>> Yours Tony
> 
> The crosstool package from Dan Kegel did a good job for this. Not sure
> it's currently maintained though. It was a very useful project, it's a
> shame if it does not live on. It would be good to have up-to-date and
> tested compilers for various architectures available on kernel.org,
> ideally with access to a package that helps building compilers for
> various architectures.
> 

Tony is taking over that work.

	-hpa
