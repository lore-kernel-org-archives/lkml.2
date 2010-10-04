Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0JDKEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:04:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab0JDKEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:04:46 -0400
Message-ID: <4CA9A69F.8000006@redhat.com>
Date: Mon, 04 Oct 2010 12:04:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        heukelum@fastmail.fm, tglx@linutronix.de, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
References: <201009152110.o8FLAJeJ015584@imap1.linux-foundation.org> <4C91F07E0200007800016B50@vpn.id2.novell.com> <20100916082816.GA25681@elte.hu> <4C91F3A30200007800016B64@vpn.id2.novell.com> <20100916101355.GA31458@elte.hu> <4C9219BC0200007800016C53@vpn.id2.novell.com> <4CA52AA5.5040402@zytor.com>
In-Reply-To: <4CA52AA5.5040402@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/01/2010 02:26 AM, H. Peter Anvin wrote:
> ... but that doesn't work with the macros like movq_cfi.  On those, we
> could argue that at least people won't put $ on them, but cpp will still
> split them apart with spaces; this apparently causes problems at least
> as soon as there is an expression more complicated than addition
> involved (apparently plus signs are okay, but minus signs aren't!)

Likely due to the fact that a minus sign can later join with a number 
and become a new token, but a plug sign cannot.

-- 
error compiling committee.c: too many arguments to function

