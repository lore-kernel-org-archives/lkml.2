Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab2JVT07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:26:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63424 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2JVT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:26:57 -0400
MIME-Version: 1.0
In-Reply-To: <20121022151927.GG22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-22-git-send-email-yinghai@kernel.org>
	<20121022151927.GG22780@phenom.dumpdata.com>
Date: Mon, 22 Oct 2012 12:26:56 -0700
X-Google-Sender-Auth: DTQ9z1J508qDR6EMovsEZSQhC0c
Message-ID: <CAE9FiQWajHEY=6xy3abxbCFv3Bo-Gp0KuqPZOGzOLBhaObaG9Q@mail.gmail.com>
Subject: Re: [PATCH 18/19] x86, mm: Let "memmap=" take more entries one time
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 8:19 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:29PM -0700, Yinghai Lu wrote:
>> Current "memmap=" only can take one entry every time.
>> when we have more entries, we have to use memmap= for each of them.
>>
>> For pxe booting, we have command line length limitation, those extra
>> "memmap=" would waste too much space.
>>
>> This patch make memmap= could take several entries one time,
>> and those entries will be split with ','
>
> Um, not sure what this patch has to do with this patchset?
> Should this be sent seperatly?

during debug those patches, need to punch hole in memmap find this problem.

thought other guys could have the same problem while test this patch set.

will move it as last one
