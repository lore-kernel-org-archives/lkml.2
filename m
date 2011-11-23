Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab1KWDX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:23:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40752 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1KWDXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:23:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111122191729.GA9581@n2100.arm.linux.org.uk>
References: <1321985779-5810-1-git-send-email-consul.kautuk@gmail.com>
	<CAFPAmTQ3su_tuwHEBKPwn4YFX8sWs0x1agYfyzTnOdBaVRL21Q@mail.gmail.com>
	<20111122191729.GA9581@n2100.arm.linux.org.uk>
Date: Wed, 23 Nov 2011 08:53:23 +0530
Message-ID: <CAFPAmTTM=jwpFkTQFnZySC2YuEdPEqM=yhbJYN-7fufr56Ssmw@mail.gmail.com>
Subject: Re: [PATCH 1/1 v5] arm: fault.c: Port OOM changes into do_page_fault
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 23, 2011 at 12:47 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 22, 2011 at 01:33:42PM -0500, kautuk.c @samsung.com wrote:
>> Please disregard this one due to the following line :
>> From: Kautuk <kautuk@ubuntu.(none)>
>>
>> There was something wrong in my git configuration.
>
> Which is the correct one?  The first?
>

This one is correct, i.e., this email chain you have replied to.
