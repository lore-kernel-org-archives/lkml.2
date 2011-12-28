Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1L1K20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 05:28:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab1L1K2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 05:28:24 -0500
Message-ID: <4EFAEF40.3090407@redhat.com>
Date: Wed, 28 Dec 2011 12:28:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Liu Ping Fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, gleb@redhat.com,
        mtosatti@redhat.com, xiaoguangrong.eric@gmail.com, jan.kiszka@web.de,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [PATCH v6] kvm: make vcpu life cycle separated from kvm instance
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com> <1324975139-8836-1-git-send-email-kernelfans@gmail.com> <4EFAE72D.3080609@redhat.com> <4EFAE74F.7000200@redhat.com> <4EFAED2E.6090403@oss.ntt.co.jp>
In-Reply-To: <4EFAED2E.6090403@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2011 12:19 PM, Takuya Yoshikawa wrote:
>> Oops, that's only needed when the unplug API is introduced.
>>
>
>
> I think it is OK to to add such an API later on, but I really want
> the author to write the plan in the changelog.

It was in fact in the beginning of the thread. 

> I am not objecting to this patch itself, but the way this kind of change
> is being introduced seems not be in a good manner.

It should be part of a patch series that adds the API, otherwise it will
never be tested.

-- 
error compiling committee.c: too many arguments to function

