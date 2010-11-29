Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0K2QfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:35:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab0K2QfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:35:15 -0500
Message-ID: <4CF3D637.6060204@redhat.com>
Date: Mon, 29 Nov 2010 18:35:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>, Glauber Costa <glommer@redhat.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 22 (kvm)
References: <20101122134911.b7e106f9.sfr@canb.auug.org.au>	<20101122132627.bd4e88ef.randy.dunlap@oracle.com> <20101129083324.6870d7da.randy.dunlap@oracle.com>
In-Reply-To: <20101129083324.6870d7da.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 06:33 PM, Randy Dunlap wrote:
> On Mon, 22 Nov 2010 13:26:27 -0800 Randy Dunlap wrote:
>
> >  On Mon, 22 Nov 2010 13:49:11 +1100 Stephen Rothwell wrote:
> >
> >  >  Hi all,
> >  >
> >  >  Changes since 20101119:
> >
> >
> >  kvm.c:(.init.text+0x11f49): undefined reference to `kvm_register_clock'
> >
> >  when CONFIG_KVM_CLOCK is not enabled.
>
>
> BUild error still present in linux-next-2010-NOV-29.
>

Glauber, Zach?

-- 
error compiling committee.c: too many arguments to function

