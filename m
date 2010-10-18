Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0JRN0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:26:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab0JRN0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:26:36 -0400
Message-ID: <4CBC4B06.3030300@redhat.com>
Date: Mon, 18 Oct 2010 15:26:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
References: <20101017085416.GA1758@darkstar> <4CBAC342.1010609@redhat.com> <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com> <4CBAE8E2.1060704@redhat.com> <AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com> <4CBBF3C8.9070104@web.de> <4CBC1047.6010501@redhat.com> <20101018125803.GA2497@darkstar>
In-Reply-To: <20101018125803.GA2497@darkstar>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/18/2010 02:58 PM, Dave Young wrote:
> >
> >  It's secondary_startup_64 enabling efer.sce and efer.nx.
> >
> >  Dave, please post your /proc/cpuinfo.  Is your host running with NX
> >  disabled?
>
> I see nx bit in /proc/cpuinfo, Actually I don't know how to disable it.

Strange.

Please patch arch/x86/kvm/x86.c to printk efer_reserved_bits (a global), 
efer (an argument) and old_efer (a local), and post the results.

-- 
error compiling committee.c: too many arguments to function

