Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab2BUT5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:57:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45198 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab2BUT5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:57:05 -0500
Message-ID: <4F43F701.80205@zytor.com>
Date: Tue, 21 Feb 2012 11:56:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, hjl.tools@gmail.com
Subject: Re: [PATCH 30/30] x32: Add x32 VDSO support
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <1329696488-16970-31-git-send-email-hpa@zytor.com> <4F42E171.9080005@mit.edu> <4F431665.3010004@zytor.com> <CAObL_7Hy8Y0PWrcZdRSGRcEt+aoma7ax4XU44f-gdHEGoWBzTg@mail.gmail.com> <4F43D98D.1020406@zytor.com> <CAObL_7GqT-CSB6uBoDvKymodEzUi3tY0DJv0U=xzYbaJS7A1nA@mail.gmail.com> <4F43EA83.6020203@zytor.com> <CAObL_7GLnDFkb61jAZEj+9gGTr4FA=8ZFVMxd9Tus4LVVmKjKw@mail.gmail.com> <4F43F25E.3030004@zytor.com> <CAObL_7H=M7-wxobKkj+K2fcrpEv0Nfp8=6gV2yvdb2hqxCTAGg@mail.gmail.com> <4F43F54D.50201@zytor.com> <CAObL_7FW7qr5cOpB=kcPaQQUgPAebm+WgzevTW8j83WKV3dFDQ@mail.gmail.com>
In-Reply-To: <CAObL_7FW7qr5cOpB=kcPaQQUgPAebm+WgzevTW8j83WKV3dFDQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 11:51 AM, Andrew Lutomirski wrote:
>>
>> No, that wouldn't help.  The situation is actually quite similar to the
>> current situation where we have an unshared fourth level, but since the
>> fourth entries are 512G per entry, we would have to push unsharing of
>> the kernel address space at least one more level (1G), possibly two
>> (2M).  Painful.
>>
>> The main advantage of a separate cr3 would be that we wouldn't need the
>> unshared top level for the kernel side.
> 
> Also, as is, if the top level wants to be per-cpu *and* per-task,
> that's a big explosion of page tables that all need to stay in sync.
> 

Fair enough.

	-hpa

