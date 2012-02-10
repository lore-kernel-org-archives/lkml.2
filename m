Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499Ab2BJRYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:24:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48300 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab2BJRYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:24:21 -0500
MIME-Version: 1.0
In-Reply-To: <4F35517F.9070904@linux.intel.com>
References: <CALCETrVWBdp2yyuZ54osq_QQ0a8NKUfOk8stxtuiFWq76FO7JQ@mail.gmail.com>
 <4F35517F.9070904@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 10 Feb 2012 09:24:01 -0800
Message-ID: <CALCETrVHpfW5=paX8XjGNBg3Q7sjeLptMBG6bW=iQpXk0Uo+PA@mail.gmail.com>
Subject: Re: Do the x86 kernel entry points need an xabort on TSX cpus?
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 9:18 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 02/09/2012 11:40 PM, Andy Lutomirski wrote:
>>
>> [...]
>>
>>  - Ring transitions: SYSENTER, SYSCALL, SYSEXIT, and SYSRET.
>>
>> I suspect that many bits of the kernel expect that things they do
>> won't unhappen.  For example, it could be fun to do:
>>
>
> That's why entering the kernel will cause an abort.  In other words, you
> will ALWAYS abort when you do a read(), and you will never reach your
> _xabort().

Is that architecturally guaranteed?  (My manual suggests that it's
specifically *not* guaranteed, which is surprising.)

--Andy
