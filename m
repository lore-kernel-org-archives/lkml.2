Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0DWFRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab0DWFRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:17:46 -0400
Message-ID: <4BD12E48.3080400@redhat.com>
Date: Fri, 23 Apr 2010 13:21:12 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Haren Myneni <hbabu@us.ibm.com>, Neil Horman <nhorman@tuxdriver.com>,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/5] Add second memory region for crash kernel
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>	<m1aasvkupc.fsf@fess.ebiederm.org> <20100422224525.GJ3228@redhat.com> <m1eii7j8ne.fsf@fess.ebiederm.org>
In-Reply-To: <m1eii7j8ne.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
>> Vitaly, have you really run into cases where 2G upper limit is a concern.
>> What is the configuration you have, how much memory it has and how much
>> memory are you planning to reserve for kdump kernel?
> 
> A good question.
> 

We have observed that on a machine which has 66G memory, when we do
crashkernel=1G@4G, kexec failed to load the crash kernel, but the memory
reservation _did_ succeed.

Thanks.
