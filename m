Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab1BASoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:44:21 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35790 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab1BASoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:44:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=c3ggLEIWGovOvPfKQLOTcARP5/OSF29+L2HijaPs303wFkam3HLanFR5pM27E2n085
         igiZtBkei4XojpG2e/YZ8vaNsY2k2C+6MjlOM/i8HeIQK2QCbMHRnjQPLEN/vpU/a2pr
         gh7cJfC3PvfNtA62zinqcKqdSIkuBiE8dMV38=
Message-ID: <4D48547F.5040905@gmail.com>
Date: Tue, 01 Feb 2011 21:44:15 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU
 0.
References: <20110201162703.2284.qmail@science.horizon.com> <4D484853.9020409@gmail.com> <20110201184110.GB21209@redhat.com>
In-Reply-To: <20110201184110.GB21209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 09:41 PM, Don Zickus wrote:
...
> 
> Unfortunately, I have not had success with patch below on my system. :-(
> 
> Cheers,
> Don

You mean it didn't help?

-- 
    Cyrill
