Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab0JEJLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:11:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280Ab0JEJK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:10:59 -0400
Message-ID: <4CAAEB67.6090005@redhat.com>
Date: Tue, 05 Oct 2010 11:09:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@novell.com>,
        heukelum@fastmail.fm, tglx@linutronix.de, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
References: <20100916082816.GA25681@elte.hu> <4C91F3A30200007800016B64@vpn.id2.novell.com> <20100916101355.GA31458@elte.hu> <4C9219BC0200007800016C53@vpn.id2.novell.com> <4CA52AA5.5040402@zytor.com> <4CA9A69F.8000006@redhat.com> <4CA9F625.7090709@zytor.com> <4CA9FEE2.7000900@redhat.com> <4CAA1BA3.1010306@zytor.com> <4CAAD85B.7020607@redhat.com> <20101005075107.GC23608@elte.hu>
In-Reply-To: <20101005075107.GC23608@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/05/2010 09:51 AM, Ingo Molnar wrote:
> >
> >  I suppose it isn't possible to refuse to build with the broken version?
>
> We could leave it build-broken and ask for a version specific quirk that
> runs a simple sed script over the source to turns 'pushl_cfi' et al into
> 'push', or so?
>

Good idea.

-- 
error compiling committee.c: too many arguments to function

