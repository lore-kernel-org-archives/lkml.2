Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2LKMvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:51:48 -0500
Received: from mga07.intel.com ([143.182.124.22]:34666 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752559Ab2LKMvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:51:46 -0500
MIME-Version: 1.0
In-Reply-To: <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	<CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
Date: Tue, 11 Dec 2012 14:51:43 +0200
Message-ID: <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Can you please comment on the feature flag in this patchset?

Thanks,
Dmitry


On Tue, Nov 27, 2012 at 3:42 PM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> Hello,
>
> Any thoughts about this proposal?
>
> - Dmitry
>
> On Thu, Nov 22, 2012 at 11:54 PM, Dmitry Kasatkin
> <dmitry.kasatkin@intel.com> wrote:
>> Hello,
>>
>> Here is two patches for policy search speedup.
>>
>> First patch adds additional features flags to superblock.
>> Second - implementation for IMA.
>>
>> Two months ago I was asking about it on mailing lists.
>> Suggestion was not to use s_flags, but e.g. s_feature_flags.
>>
>> Any objections about such approach?
>>
>> Thanks,
>> Dmitry
>>
>> Dmitry Kasatkin (2):
>>   vfs: new super block feature flags attribute
>>   ima: skip policy search for never appraised or measured files
>>
>>  include/linux/fs.h                  |    4 ++++
>>  security/integrity/ima/ima_api.c    |    8 ++------
>>  security/integrity/ima/ima_policy.c |   20 +++++++++++++++++---
>>  security/integrity/integrity.h      |    3 +++
>>  4 files changed, 26 insertions(+), 9 deletions(-)
>>
>> --
>> 1.7.10.4
>>
