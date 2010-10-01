Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab0JABs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 21:48:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50350 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab0JABs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:48:56 -0400
Message-ID: <4CA53DDE.5000901@zytor.com>
Date: Thu, 30 Sep 2010 18:48:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        heukelum@fastmail.fm, tglx@linutronix.de,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
References: <201009152110.o8FLAJeJ015584@imap1.linux-foundation.org>	<4C91F07E0200007800016B50@vpn.id2.novell.com>	<20100916082816.GA25681@elte.hu>	<4C91F3A30200007800016B64@vpn.id2.novell.com>	<20100916101355.GA31458@elte.hu>	<4C9219BC0200007800016C53@vpn.id2.novell.com>	<4CA52AA5.5040402@zytor.com> <20100930180100.4607034f.akpm@linux-foundation.org>
In-Reply-To: <20100930180100.4607034f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2010 06:01 PM, Andrew Morton wrote:
>>
>> ... which these old versions of gas considers multiple arguments to the
>> macro, even though there is no comma anywhere.
> 
> Could we run another little program after cpp which takes the spaces
> out again?
> 

We could try using the -traditional option to cpp, I don't know if that
would break anything else.  We *used* to use it, and finally got rid of
it...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

