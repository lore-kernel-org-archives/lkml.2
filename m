Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2IHR4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:56:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63291 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2IHR4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:56:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120908175007.GF10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
	<CACvQF50he+TtSqRBA-WAbGNqu4BRKtDQoP67ukEhinO3iDRPcg@mail.gmail.com>
	<20120908173751.GC10788@dhcp-172-17-108-109.mtv.corp.google.com>
	<CACvQF50cY8YEx30DR8K0KHF4pkc3f2b4WxVz_1bAxwbXoGMrBg@mail.gmail.com>
	<20120908175007.GF10788@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Sun, 9 Sep 2012 01:56:47 +0800
Message-ID: <CACvQF52HQgrVEQFeOhQc=y+iFbc55-X9TC96wVvoV6g77Ze=Eg@mail.gmail.com>
Subject: Re: [PATCH 0/7 V6] workqueue: fix hoplug things
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 1:50 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Lai.
>
> On Sun, Sep 09, 2012 at 01:46:59AM +0800, Lai Jiangshan wrote:
>> > * Instead of MANAGING, add pool->manager.
>> >
>> > * Fix the idle depletion bug by using pool->manager for exclusion and
>> >   always grabbing pool->manager_mutex.  Hotplug can use pool->manager
>> >   to schedule rebind work (or UNBIND) to the manager.
>> >
>> > Thoughts?
>>
>> Don't need.  my worry is wrong.
>
> So, your worry was incorrect and the above is what we're gonna do, no?

NO BUG found for PATCH4 even idle rebinding is synchronous.
