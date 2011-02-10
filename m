Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1BJKkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 05:40:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab1BJKks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 05:40:48 -0500
Message-ID: <4D53C0A9.9020402@redhat.com>
Date: Thu, 10 Feb 2011 12:40:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH] KVM: x86: Convert tsc_write_lock to raw_spinlock
References: <4D4BCB97.6000900@siemens.com>
In-Reply-To: <4D4BCB97.6000900@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 11:49 AM, Jan Kiszka wrote:
> Code under this lock requires non-preemptibility. Ensure this also over
> -rt by converting it to raw spinlock.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

