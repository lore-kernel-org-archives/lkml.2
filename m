Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0HBS7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:59:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43365 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab0HBS7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:59:09 -0400
Message-ID: <4C57153F.7030107@zytor.com>
Date: Mon, 02 Aug 2010 11:58:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/2] x86: more early console output from	compressed/misc.c
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <4C568D6F.3050004@kernel.org> <20100802174916.GD5544@lenovo> <4C5710C1.8020809@zytor.com> <20100802185410.GE5544@lenovo>
In-Reply-To: <20100802185410.GE5544@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 11:54 AM, Cyrill Gorcunov wrote:
> 
> ok, fair enough, I just don't like nesting *.c inclusion you know but seems
> it would be the only more-less clean way here.
> 

I don't mind it *as long as* the including file contains nothing but a
single #include statement -- which is just another way to say "the same
thing as this other file".  Don't combine files.

Look at most of the .c files in arch/x86/kernel/acpi/realmode/ for an
example.

	-hpa

