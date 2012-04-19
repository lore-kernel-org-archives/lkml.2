Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2DSAOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:14:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37062 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2DSAOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:14:43 -0400
MIME-Version: 1.0
In-Reply-To: <4F8F57CE.3070705@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
	<tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
	<CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com>
	<4F8EFE4D.2040201@zytor.com>
	<CAMe9rOpfPQghra1PQTUwsFOvjgNpzFDEGS5=BbFBjn=HZGL93g@mail.gmail.com>
	<4F8F0385.5090901@zytor.com>
	<CAMe9rOq7LduF4aLPe9qatedxps4WPCgOHTD=E_Lje4_tu6tyZw@mail.gmail.com>
	<4F8F0614.9010604@zytor.com>
	<CAMe9rOqBd29LKB==NaKscpedRMR1uL_ZhHqSw1HQj-3_d9PSCw@mail.gmail.com>
	<4F8F30F5.9030704@zytor.com>
	<CAMe9rOq-dEFtYDgpC2z3MPujCkOUtBU4byHC_aAOWLUK8u5ZDQ@mail.gmail.com>
	<4F8F52D5.3040109@zytor.com>
	<CAMe9rOofzJg+Q1M8cDw0ebVLZodq_0BN=A-ytpmdHZzE9LORtg@mail.gmail.com>
	<4F8F57CE.3070705@zytor.com>
Date: Wed, 18 Apr 2012 17:14:42 -0700
Message-ID: <CAMe9rOrjyh13MXCVgPLtZemjrkSC3uoMhB4_WCsXVjv7T2nMJg@mail.gmail.com>
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 5:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/18/2012 04:54 PM, H.J. Lu wrote:
>>>
>>> We could.  If we want to align the substructures then we need some major
>>> surgery to the compat_siginfo handling though.
>>>
>>
>> Since there will be no x32 kernel, align struct siginfo to 8byte for x32
>> will only be for user space code.  It shouldn't be a problem for kernel.
>>
>
> Well, for aligning the whole structure I don't think there is any change
> to the kernel at all...
>

That is true.  This is only by user codes to pass 8bye aligned
struct siginfo pointer to kernel.

-- 
H.J.
