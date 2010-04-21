Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0DUItW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:49:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab0DUItU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:49:20 -0400
Message-ID: <4BCEBC07.2090204@redhat.com>
Date: Wed, 21 Apr 2010 11:49:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: simplify kvm_vm_ioctl_set_memory_alias
References: <4BC97D62.2090908@cn.fujitsu.com>
In-Reply-To: <4BC97D62.2090908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2010 12:20 PM, Lai Jiangshan wrote:
> It's just time waste if we free a object and allocate it immediately.
>    

The alias code is scheduled to be killed off soon, (see 
Documentation/feature-removal-schedule.txt), so there's not much point 
in optimizing it.

-- 
error compiling committee.c: too many arguments to function

