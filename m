Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0HWK1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:27:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab0HWK1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:27:37 -0400
Message-ID: <4C724D13.6000807@redhat.com>
Date: Mon, 23 Aug 2010 13:27:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4 v2] kvm: rework KVM mmu_shrink() code
References: <20100820011054.GA11297@tpepper-t61p.dolavim.us> <4C724BDB.8020604@redhat.com>
In-Reply-To: <4C724BDB.8020604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/23/2010 01:22 PM, Avi Kivity wrote:
>
>
> I see a lot of soft lockups with this patchset:

This is running the emulator.flat test case, with shadow paging.  This 
test triggers a lot (millions) of mmu mode switches.

-- 
error compiling committee.c: too many arguments to function

