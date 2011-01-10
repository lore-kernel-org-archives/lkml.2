Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1AJIO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:14:56 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:44398 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab1AJIOy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Mon, 10 Jan 2011 03:14:54 -0500
Message-Id: <4D2ACE08020000780002B481@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 10 Jan 2011 08:14:48 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "David Rientjes" <rientjes@google.com>
Cc: "Tejun Heo" <tj@kernel.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
 <4D26D3FD020000780002AED9@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101070156050.19087@chino.kir.corp.google.com>
 <4D26F3AE020000780002AF5D@vpn.id2.novell.com>
 <20110107125722.GA23185@elte.hu>
 <4D272413020000780002B009@vpn.id2.novell.com>
 <20110107142203.GA12773@elte.hu>
 <4D2730BE020000780002B040@vpn.id2.novell.com>
 <20110107151254.GA418@elte.hu>
 <alpine.DEB.2.00.1101071148120.31653@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1101071148120.31653@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.01.11 at 20:55, David Rientjes <rientjes@google.com> wrote:
> I still don't think it meets the stable kernel rules.  The changelog 
> explicitly states that we do not want to disable ACPI completely, so the 
> only numa= command line option that would possibly be useful on 32-bit is 
> numa=off in this case.  If you're compiling a 32-bit kernel for a machine 
> with SRAT entries that can't be parsed by the kernel, then there's still 
> no explanation as to why CONFIG_NUMA=n won't fix it.

In distro kernels you have no control over the configuration, yet you
may want the kernel to boot on a particular machine.

Jan

