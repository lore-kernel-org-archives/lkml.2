Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1IWHbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 03:31:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19435 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1IWHbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 03:31:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=nzL00Lg+ZBSncUi64BbwgSmanUngV9C9AN6mp9W2C0WDaRNXai7flsCLgJ6pxs1md
	j55SF2zixULoqy7eKHObw==
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFDaYxevsH8UYEeZJrz7HCZSg89_XTaXP=hPTTG2HH9=w@mail.gmail.com>
References: <20110922123128.GA9761@quad>
	<CAOJsxLFDaYxevsH8UYEeZJrz7HCZSg89_XTaXP=hPTTG2HH9=w@mail.gmail.com>
Date: Fri, 23 Sep 2011 09:31:04 +0200
Message-ID: <CABPqkBQSBKS+bnLhStzV4PTrE+Qrb1XyeR5FEyn4d+NFZrhuOQ@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
From: Stephane Eranian <eranian@google.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com, robert.richter@amd.com,
        ak@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 8:40 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Thu, Sep 22, 2011 at 3:31 PM, Stephane Eranian <eranian@google.com> wrote:
>> # CPU0 sibling cores  : 0-3
>> # CPU0 sibling threads: 0
>> # CPU1 sibling cores  : 0-3
>> # CPU1 sibling threads: 1
>> # CPU2 sibling cores  : 0-3
>> # CPU2 sibling threads: 2
>> # CPU3 sibling cores  : 0-3
>> # CPU3 sibling threads: 3
>> # total memory: 8093212 kB
>> # cpuid : GenuineIntel,6,15,11
>
> So how important is this information? The output is going to be somewhat
> awkward for very large CPU counts... :-)
>
It is useful to determine how CPUs share caches for instance.
It can get large but large, but the meta-data header is not printed by
default, you need to request it with the -I option.
