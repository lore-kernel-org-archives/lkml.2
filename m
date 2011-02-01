Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1BAUBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:01:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43103 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1BAUA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:00:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MhJkSqSRE1u9oqlbjnAZs30hilEaW+DqhaSIV4b+wh0gLjfRc54Zb94wfWqqynpi0H
         CSH+uS1zTNfCkYxrPVt0UZHd+DQMPIGzfTKjAiA1NboCixMsMunENiN32n7cc3lwsdY1
         P2OMooPoJ9c/OcKLIxt69u41B2y6fn+Wb4/LM=
Message-ID: <4D486677.4080002@gmail.com>
Date: Tue, 01 Feb 2011 23:00:55 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU
 0.
References: <20110201162703.2284.qmail@science.horizon.com> <4D484853.9020409@gmail.com> <20110201184110.GB21209@redhat.com> <4D48547F.5040905@gmail.com> <20110201185120.GD21209@redhat.com>
In-Reply-To: <20110201185120.GD21209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 09:51 PM, Don Zickus wrote:
...
>>
>> You mean it didn't help?
> 
> Not that I noticed no.
> 
> Cheers,
> Don

 Thanks a huge for testing, Don! I'll check what else I can do.

-- 
    Cyrill
