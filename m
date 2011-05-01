Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1EAW7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 18:59:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51654 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab1EAW7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 18:59:50 -0400
Message-ID: <4DBDE5C0.1030907@zytor.com>
Date: Sun, 01 May 2011 15:59:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hans Rosenfeld <hans.rosenfeld@amd.com>, brgerst@gmail.com,
        tglx@linutronix.de, mingo@elte.hu, suresh.b.siddha@intel.com,
        eranian@google.com, robert.richter@amd.com, Andreas.Herrmann3@amd.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fork: avoid weak function arch_dup_task_struct
References: <2be7032a-e4b6-4ce7-af53-532d77dbfb48@email.android.com>	<1303914395-841373-2-git-send-email-hans.rosenfeld@amd.com> <20110501122559.bbf91079.akpm@linux-foundation.org>
In-Reply-To: <20110501122559.bbf91079.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2011 12:25 PM, Andrew Morton wrote:
> On Wed, 27 Apr 2011 16:26:35 +0200 Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> 
>> Avoid potential gcc bug by not using a weak function for
>> arch_dup_task_struct. Use an #ifdef'ed static function for
>> archs that don't have a special arch_dup_task_struct implementation.
> 
> The patch is unreviewable (and hence unusable) if you don't describe
> this "potential gcc bug".
>

http://lkml.indiana.edu/hypermail/linux/kernel/0804.3/3202.html

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

