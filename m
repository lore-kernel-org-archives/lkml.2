Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1IBHiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:38:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33187 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab1IBHiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:38:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAORVsuVkxHTEr5J9F1USr3csMoCELDfk9ixeG3kddy6oRj5RUw@mail.gmail.com>
References: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
	<201108192231.02665.trenn@suse.de>
	<CACVXFVPeFyg7YoAsY63Mpy9HVR1y3ibg9R8HnUfLVe=hKf3ApA@mail.gmail.com>
	<201108221027.34441.trenn@suse.de>
	<CAORVsuVkxHTEr5J9F1USr3csMoCELDfk9ixeG3kddy6oRj5RUw@mail.gmail.com>
Date: Fri, 2 Sep 2011 15:38:07 +0800
Message-ID: <CACVXFVOq2Hn-ZED2LyRQjk72mWJ5N=_LbVw3-vvrK-xUtKZGhQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] trace points: power: remove 'cpu_id' from trace_cpu_idle
From: Ming Lei <tom.leiming@gmail.com>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: Thomas Renninger <trenn@suse.de>, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 2, 2011 at 3:26 PM, Jean Pihet <jean.pihet@newoldbits.com> wrote:
>> It was known that cpu_id is always the current cpu with current
>> implementation when this got introduced.
>> But the perf events API must not change back and forth for userspace
>> compatibility. Therefore the cpu_id was added in case
>> that future implementations want to pass info where the current cpu
>> is not the cpu which is sent to the sleep state.
> Agree. Let's keep the cpu_id field.

OK, let's keep it.

How about removing it in clock_enalbe/clock_disable/power_domain_target
as did in [1/3] and [2/3]?  I don't see any usefulness of 'cpu_id' in the tree
trace points.


thanks,
-- 
Ming Lei
