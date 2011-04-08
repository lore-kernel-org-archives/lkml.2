Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab1DHSqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:46:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58820 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab1DHSqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:46:18 -0400
Message-ID: <4D9F57CE.1080903@zytor.com>
Date: Fri, 08 Apr 2011 11:45:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: tip: New "Link:" tag to replace "LKML-Reference:"
References: <4D9CE4AE.4090303@zytor.com> <BANLkTinT=UoVCwwEcpfPvCCL-e-Zh0r1qw@mail.gmail.com>
In-Reply-To: <BANLkTinT=UoVCwwEcpfPvCCL-e-Zh0r1qw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 07:36 AM, Bjorn Helgaas wrote:
> On Wed, Apr 6, 2011 at 4:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Hi all,
>>
>> At Linus' request, I have modified the tip-bot to recognize a new form
>> of email archive references, which should work as clickable links.
>> Instead of:
>>
>> LKML-Reference: <message-id>
>>
>> use, instead:
>>
>> Link: http://lkml.kernel.org/r/message-id
> 
> Really cool idea.  I assume you'll mention this in
> Documentation/SubmittingPatches or somewhere similar.
> 

Well, it is better done by the committers rather than the patch
submitters, so it's mostly an issue for people using git as opposed to
submitting patches by email.

	-hpa

