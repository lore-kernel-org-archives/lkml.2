Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0DUIln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab0DUIlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:41:42 -0400
Message-ID: <4BCEBA41.9050705@redhat.com>
Date: Wed, 21 Apr 2010 11:41:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: do not need hardware_disable when CPU_UP_CANCELED
References: <4BC978A3.8010502@cn.fujitsu.com>
In-Reply-To: <4BC978A3.8010502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2010 12:00 PM, Lai Jiangshan wrote:
> When CPU_UP_CANCELED, hardware_enable() has not been called at the CPU
> which is going up because raw_notifier_call_chain(CPU_ONLINE)
> has not been called for this cpu.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

