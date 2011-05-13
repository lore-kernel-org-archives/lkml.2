Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab1EMPJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:09:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39992 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab1EMPJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:09:13 -0400
MIME-Version: 1.0
X-Originating-IP: [81.245.76.63]
In-Reply-To: <20110513144830.GB32688@elte.hu>
References: <1305297838-4015-1-git-send-email-j-pihet@ti.com>
	<20110513144830.GB32688@elte.hu>
Date: Fri, 13 May 2011 17:09:12 +0200
Message-ID: <BANLkTikkd9bNRLF1iDAz9Jwrnon3A=j44g@mail.gmail.com>
Subject: Re: [PATCH] perf: export power_start and power_end tracepoints
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Jean Pihet <j-pihet@ti.com>, linux-omap@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding l-o and linux-pm MLs. The original post is at
http://www.spinics.net/lists/kernel/msg1186554.html

On Fri, May 13, 2011 at 4:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * jean.pihet@newoldbits.com <jean.pihet@newoldbits.com> wrote:
>
>> From: Jean Pihet <j-pihet@ti.com>
>>
>> If used in a module both tracepoints need to be exported by the
>> kernel.
>
> but it's not used by any module in the kernel AFAICS, so why is this needed?
Not currently, that is why the error went unnoticed. I think it is
better to fix it now than later.

I am working on a plan to clean-up and isolate the OMAP PM code from
the core code and to provide the PM functionality as a module. This
effort is part of the 'remove the crazy ARM churn' from the kernel.

Thanks,
Jean

>
> Thanks,
>
>        Ingo
>
