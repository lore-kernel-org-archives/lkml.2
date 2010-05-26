Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071Ab0EZRbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:31:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:51300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126Ab0EZRbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:31:19 -0400
Subject: Re: Clock jumps
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4BFD5616.6070302@cora.nwra.com>
Date: Wed, 26 May 2010 19:31:15 +0200
Cc: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>
References: <loom.20100524T171038-56@post.gmane.org> <20100525062100.GP22163@redhat.com> <4BFD5616.6070302@cora.nwra.com>
To: Orion Poplawski <orion@cora.nwra.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26.05.2010, at 19:10, Orion Poplawski wrote:

> On 05/25/2010 12:21 AM, Gleb Natapov wrote:
>> Adding kvm to CC.
>> 
>> On Mon, May 24, 2010 at 04:06:32PM +0000, Orion Poplawski wrote:
>>> I have a KVM virtual machine running 2.6.33.4-95.fc13.x86_64 on a CentOS 5.5
>>> host whose clock jumps about 8-12 hours a couple times a day.  I have no idea
>>> what is causing it.  Fedora 12 and Centos 5.5 KVM machines run fine on the same
>>> host.  Is there any debugging I can enable to see what is jumping the clock?
>>> 
>>> kvm-clock: cpu 0, msr 0:1ba4741, boot clock
>>> kvm-clock: cpu 0, msr 0:1e15741, primary cpu clock
>>> Switching to clocksource kvm-clock
>>> rtc_cmos 00:01: setting system clock to 2010-05-20 16:59:48 UTC (1274374788)
> 
> 
> Thanks, though I don't think it made it there.  I'm also not sure it's completely limited to KVM, though that is the only running system I am currently seeing the problem on.  I also see clock jumps during anaconda installs on physical hardware and apparently they have been present since at least F11.  Might be unrelated though.
> 
> I'm really at a loss of how to debug this though.

Do you have ntpd running inside the guest? I have a bug report lying around about 2.6.33 with kvm-clock jumping in time when ntpd is used: https://bugzilla.novell.com/show_bug.cgi?id=582260

Alex

