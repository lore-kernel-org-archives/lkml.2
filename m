Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1BHOiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:38:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36683 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1BHOiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:38:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QikoriOysZQpX6kM6eDLQ2eXfZoCOK1JCkp+cp0SdxvbE09HpIKoBltPFx+jjLmCX6
         tDzUb5EneylsPYzmWI78L2XwY1v+DMa1c29wNSSwmC/hE+ik4ss0WWOFbczEhIykXmtw
         Kuh7mErK1Y0sMGDyTLh4cc+hqK5TaX+wXSwhc=
Message-ID: <4D515556.6090807@gmail.com>
Date: Tue, 08 Feb 2011 17:38:14 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: dzickus@redhat.com, a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com, mingo@elte.hu,
        mroos@linux.ee
Subject: Re: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
References: <20110208142615.19960.qmail@science.horizon.com>
In-Reply-To: <20110208142615.19960.qmail@science.horizon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 05:26 PM, George Spelvin wrote:
> I don't use kgdb, so I can't comment on that, but patch #2
> ("perf, x86: P4 PMU -- Fix unflagged overflows test")
> has given me no problems in 3.5 days of uptime.
> 
> Thank you very much!

Thanks for testing George! I'm still investigatin this issue
(though didn't manage to spend more time today but there are
 some results obtained I need to analyze first).

-- 
    Cyrill
