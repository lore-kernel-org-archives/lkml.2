Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1AGO07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:26:59 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:47204 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab1AGO06 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 7 Jan 2011 09:26:58 -0500
Message-Id: <4D2730BE020000780002B040@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 07 Jan 2011 14:26:54 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "David Rientjes" <rientjes@google.com>, "Tejun Heo" <tj@kernel.org>,
        <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
 <4D26D3FD020000780002AED9@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101070156050.19087@chino.kir.corp.google.com>
 <4D26F3AE020000780002AF5D@vpn.id2.novell.com>
 <20110107125722.GA23185@elte.hu>
 <4D272413020000780002B009@vpn.id2.novell.com>
 <20110107142203.GA12773@elte.hu>
In-Reply-To: <20110107142203.GA12773@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.01.11 at 15:22, Ingo Molnar <mingo@elte.hu> wrote:
> Your -stable comment above made it appear to me as if you knew about a 
> specific 
> system that crashed this way? As long as it's only theoretical i'm not sure 
> it 
> warrants a -stable backport.

Yes, I do have a system affected (which made me craft the patch
in the first place).

Jan

