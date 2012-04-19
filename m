Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2DSAKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:10:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43369 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab2DSAJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:09:59 -0400
Message-ID: <4F8F57CE.3070705@zytor.com>
Date: Wed, 18 Apr 2012 17:09:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org> <CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com> <4F8EFE4D.2040201@zytor.com> <CAMe9rOpfPQghra1PQTUwsFOvjgNpzFDEGS5=BbFBjn=HZGL93g@mail.gmail.com> <4F8F0385.5090901@zytor.com> <CAMe9rOq7LduF4aLPe9qatedxps4WPCgOHTD=E_Lje4_tu6tyZw@mail.gmail.com> <4F8F0614.9010604@zytor.com> <CAMe9rOqBd29LKB==NaKscpedRMR1uL_ZhHqSw1HQj-3_d9PSCw@mail.gmail.com> <4F8F30F5.9030704@zytor.com> <CAMe9rOq-dEFtYDgpC2z3MPujCkOUtBU4byHC_aAOWLUK8u5ZDQ@mail.gmail.com> <4F8F52D5.3040109@zytor.com> <CAMe9rOofzJg+Q1M8cDw0ebVLZodq_0BN=A-ytpmdHZzE9LORtg@mail.gmail.com>
In-Reply-To: <CAMe9rOofzJg+Q1M8cDw0ebVLZodq_0BN=A-ytpmdHZzE9LORtg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 04:54 PM, H.J. Lu wrote:
>>
>> We could.  If we want to align the substructures then we need some major
>> surgery to the compat_siginfo handling though.
>>
> 
> Since there will be no x32 kernel, align struct siginfo to 8byte for x32
> will only be for user space code.  It shouldn't be a problem for kernel.
> 

Well, for aligning the whole structure I don't think there is any change
to the kernel at all...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

