Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab2BXPwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:52:00 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56080 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481Ab2BXPv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:51:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.112.31.232 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
MIME-Version: 1.0
In-Reply-To: <4F47B1A3.6050503@gmail.com>
References: <20120224094048.GA7952@quad>
	<4F47ABAD.9080408@gmail.com>
	<CABPqkBT1R_SJiQkjujS4dN5yQZPakjOmmCLNR3DmNxTmVT_p9A@mail.gmail.com>
	<4F47AD6A.6080609@gmail.com>
	<CABPqkBQyBtxO3ytcZKHyGNAiwYzmqODy+C-EY5gQTENKtngBFw@mail.gmail.com>
	<4F47B1A3.6050503@gmail.com>
Date: Fri, 24 Feb 2012 16:51:56 +0100
Message-ID: <CABPqkBT=po0=-oi0GgGEVCNCxuSMwMyh5vPz=sWcNrqSZDc68Q@mail.gmail.com>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        asharma@fb.com, robert.richter@amd.com, ming.m.lin@intel.com,
        vweaver1@eecs.utk.edu, andi@firstfloor.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 4:49 PM, David Ahern <dsahern@gmail.com> wrote:
> On 2/24/12 8:40 AM, Stephane Eranian wrote:
>>
>> No, I don't. Read the code carefully. The for loop sets all known feature
>> bits.
>> Then, the ones not necessary or unused are turned off individually.
>
>
> Ok, I see now. The __set_feat loop is earlier in builtin-record.c, not the
> util code.
>
Yeah. Arnaldo simplified the original code in builtin-record.c to have the loop
instead of individual set_feat().

> David
