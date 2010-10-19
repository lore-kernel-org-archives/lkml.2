Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab0JSI6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab0JSI6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:58:07 -0400
Message-ID: <4CBD5D8F.6020505@redhat.com>
Date: Tue, 19 Oct 2010 10:57:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>	<4CBAE8E2.1060704@redhat.com>	<AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>	<4CBBF3C8.9070104@web.de>	<4CBC1047.6010501@redhat.com>	<20101018125803.GA2497@darkstar>	<4CBC4B06.3030300@redhat.com>	<20101018134508.GA11885@darkstar>	<4CBC4FA9.90406@redhat.com>	<4CBC5097.1020105@redhat.com>	<20101018135813.GA20316@darkstar>	<4CBC547A.8080700@redhat.com>	<4CBC964B.6000605@zytor.com>	<AANLkTimLKjo+5BRFpOOb72qLrUnxfLXJQ6cwPwNsHHeB@mail.gmail.com>	<4CBD099D.2060500@zytor.com> <AANLkTi=bYezfR6Gxy6_gXrAmsFTVOLJCex36BGmnEc28@mail.gmail.com>
In-Reply-To: <AANLkTi=bYezfR6Gxy6_gXrAmsFTVOLJCex36BGmnEc28@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/19/2010 08:55 AM, Dave Young wrote:
> >  OK.  Please install msr-tools on your system, and give us the outputs of:
> >
> >  rdmsr -p 0 -xc 0x1a0
> 0x1764952489
>
> >  rdmsr -p 1 -xc 0x1a0
> 0x1364952489
>

That's MSR_IA32_MISC_ENABLE_XD_DISABLE.  Looks like the kernel never 
plays with it.

Suggest:
- updating your BIOS
- playing with the NX feature in your BIOS setup screens


-- 
error compiling committee.c: too many arguments to function

