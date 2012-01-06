Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab2AFXNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:13:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56507 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab2AFXNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:13:30 -0500
Message-ID: <4F077FDD.8080201@zytor.com>
Date: Fri, 06 Jan 2012 15:12:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
References: <20120105182846.GQ11715@one.firstfloor.org> <4F0630CC.7050001@zytor.com> <20120106014748.GS11715@one.firstfloor.org> <4F06566B.8080708@zytor.com> <20120106094922.GU11715@one.firstfloor.org> <4F06D979020000780006AC49@nat.nue.novell.com> <20120106103734.GV11715@one.firstfloor.org> <4F06DFEF020000780006AC84@nat28.tlf.novell.com> <20120106110845.GW11715@one.firstfloor.org> <4F06F640020000780006ACDE@nat28.tlf.novell.com> <20120106194400.GX11715@one.firstfloor.org>
In-Reply-To: <20120106194400.GX11715@one.firstfloor.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 11:44 AM, Andi Kleen wrote:
>> enough beyond 292G. At some later point ->node_page_cgroup[]
>> also exceeds 4G. Finally, the phys-to-machine mapping (which gets
>> resized during boot) exceeds 4G when crossing the 2T boundary.
> 
> Ok it's moot then because the old systems with problem didn't have
> that much memory. So you could do without an errata workaround
> and just extend the moves at the minor cost of a few prefixes
> (I think that is what you did in your patch)
> 

That seems like the way to go unless we can identify a real problem.

	-hpa

