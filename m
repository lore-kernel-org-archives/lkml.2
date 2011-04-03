Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab1DCIYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 04:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1DCIYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 04:24:10 -0400
Message-ID: <4D982E89.8070502@redhat.com>
Date: Sun, 03 Apr 2011 11:23:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com, mingo@elte.hu
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>
In-Reply-To: <1301592656.586.15.camel@jaguar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 07:30 PM, Pekka Enberg wrote:
> Hi all,
>
> We’re proud to announce the native Linux KVM tool!

So that's where you disappeared - I was following your old repository.

> The goal of this tool is to provide a clean, from-scratch, lightweight
> KVM host tool implementation that can boot Linux guest images (just a
> hobby, won't be big and professional like QEMU) with no BIOS
> dependencies and with only the minimal amount of legacy device
> emulation.
>
> Note that this is a development prototype for the time being: there's no
> networking support and no graphics support, amongst other missing
> essentials.

Mind posting a roadmap?  I would put smp support near the top.  This 
sort of thing has to be designed in, otherwise you wind up with a big 
lock like qemu.


-- 
error compiling committee.c: too many arguments to function

