Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0JSPbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:31:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55654 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab0JSPbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:31:43 -0400
X-User-Agent: K-9 Mail for Android
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com> <4CBAE8E2.1060704@redhat.com> <AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com> <4CBBF3C8.9070104@web.de> <4CBC1047.6010501@redhat.com> <20101018125803.GA2497@darkstar> <4CBC4B06.3030300@redhat.com> <20101018134508.GA11885@darkstar> <4CBC4FA9.90406@redhat.com> <4CBC5097.1020105@redhat.com> <20101018135813.GA20316@darkstar> <4CBC547A.8080700@redhat.com> <4CBC964B.6000605@zytor.com> <AANLkTimLKjo+5BRFpOOb72qLrUnxfLXJQ6cwPwNsHHeB@mail.gmail.com> <4CBD099D.2060500@zytor.com> <AANLkTi=bYezfR6Gxy6_gXrAmsFTVOLJCex36BGmnEc28@mail.gmail.com> <4CBD5D8F.6020505@redhat.com> <a4d1e098-7b9b-43f8-b341-2e0dbf1db780@email.android.com> <4CBDB38E.7090801@redhat.com>
In-Reply-To: <4CBDB38E.7090801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 19 Oct 2010 08:31:12 -0700
To: Avi Kivity <avi@redhat.com>
CC: Dave Young <hidave.darkstar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <e800d7e3-5d72-4eb2-a782-23dbbfddcb28@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That would probably be a good idea.  The kernel also sets and clears bits for various errata or other special issues.

"Avi Kivity" <avi@redhat.com> wrote:

>  On 10/19/2010 04:56 PM, H. Peter Anvin wrote:
>> Right... note in particular that the BIOS sets them up inconsistently.  The kernel is doing the rufht thing: since NX isn't available on all processors it is considered unavailable.
>
>I guess kvm should be modified to mask GET_SUPPORTED_CPUID results with 
>the boot_cpu features.  This will make kvm take advantage of the core 
>kernel doing the right thing.
>

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
