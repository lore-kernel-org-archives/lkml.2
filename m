Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab2CBRrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:47:41 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38776 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab2CBRrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:47:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.152.145.135 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
MIME-Version: 1.0
In-Reply-To: <CABPqkBT=po0=-oi0GgGEVCNCxuSMwMyh5vPz=sWcNrqSZDc68Q@mail.gmail.com>
References: <20120224094048.GA7952@quad>
	<4F47ABAD.9080408@gmail.com>
	<CABPqkBT1R_SJiQkjujS4dN5yQZPakjOmmCLNR3DmNxTmVT_p9A@mail.gmail.com>
	<4F47AD6A.6080609@gmail.com>
	<CABPqkBQyBtxO3ytcZKHyGNAiwYzmqODy+C-EY5gQTENKtngBFw@mail.gmail.com>
	<4F47B1A3.6050503@gmail.com>
	<CABPqkBT=po0=-oi0GgGEVCNCxuSMwMyh5vPz=sWcNrqSZDc68Q@mail.gmail.com>
Date: Fri, 2 Mar 2012 18:47:38 +0100
Message-ID: <CABPqkBTBkrA5qdeyhznr48Pqa9L-EX-LABypX55f_GoMRk-hDg@mail.gmail.com>
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

Arnaldo,

What do you think about this patch?


On Fri, Feb 24, 2012 at 4:51 PM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Feb 24, 2012 at 4:49 PM, David Ahern <dsahern@gmail.com> wrote:
>> On 2/24/12 8:40 AM, Stephane Eranian wrote:
>>>
>>> No, I don't. Read the code carefully. The for loop sets all known feature
>>> bits.
>>> Then, the ones not necessary or unused are turned off individually.
>>
>>
>> Ok, I see now. The __set_feat loop is earlier in builtin-record.c, not the
>> util code.
>>
> Yeah. Arnaldo simplified the original code in builtin-record.c to have the loop
> instead of individual set_feat().
>
>> David
