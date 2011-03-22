Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab1CVQlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370Ab1CVQlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:41:21 -0400
Message-ID: <4D88D126.6060908@redhat.com>
Date: Tue, 22 Mar 2011 18:41:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jean-philippe.menil@univ-nantes.fr,
        stable@kernel.org, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] kvm: fix crash on irqfd deassign
References: <20110317085333.GA7336@redhat.com>
In-Reply-To: <20110317085333.GA7336@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 10:53 AM, Michael S. Tsirkin wrote:
> irqfd in kvm used flush_work incorrectly:
> it assumed that work scheduled previously can't run
> after flush_work, but since kvm uses a non-reentrant
> workqueue (by means of schedule_work)
> we need flush_work_sync to get that guarantee.
>

Applied, and queued for 2.6.39.  Thanks.

-- 
error compiling committee.c: too many arguments to function

