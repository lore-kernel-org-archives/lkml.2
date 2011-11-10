Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1KJKLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:11:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab1KJKLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:11:48 -0500
Message-ID: <4EBBA303.9000307@redhat.com>
Date: Thu, 10 Nov 2011 18:10:11 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
CC: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ananth Narayan <ananth@in.ibm.com>, Milton Miller <miltonm@bga.com>,
        Haren Myneni <hbabu@us.ibm.com>, Anton Blanchard <anton@samba.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH v4 10/10] fadump: Introduce config option for firmware
 assisted dump feature
References: <20111107095215.1997.14866.stgit@mars.in.ibm.com> <20111107095630.1997.54984.stgit@mars.in.ibm.com>
In-Reply-To: <20111107095630.1997.54984.stgit@mars.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月07日 17:56, Mahesh J Salgaonkar 写道:
> From: Mahesh Salgaonkar<mahesh@linux.vnet.ibm.com>
>
> This patch introduces a new config option CONFIG_FA_DUMP for firmware
> assisted dump feature on Powerpc (ppc64) architecture.
>

I think this patch can be folded into the 02/10, as this config
is already used there.

Thanks.
