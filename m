Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934242Ab1KJJ5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:57:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934069Ab1KJJ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:57:52 -0500
Message-ID: <4EBB9FEE.9090905@redhat.com>
Date: Thu, 10 Nov 2011 17:57:02 +0800
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
Subject: Re: [RFC PATCH v4 02/10] fadump: Reserve the memory for firmware
 assisted	dump.
References: <20111107095215.1997.14866.stgit@mars.in.ibm.com> <20111107095527.1997.79902.stgit@mars.in.ibm.com>
In-Reply-To: <20111107095527.1997.79902.stgit@mars.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mahesh,

Your patch seems have some style problems... checkpatch.pl complains,

total: 330 errors, 1 warnings, 355 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
       scripts/cleanfile

Could use scripts/checkpatch.pl to check your patch?

Thanks.
