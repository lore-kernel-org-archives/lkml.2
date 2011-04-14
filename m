Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab1DNRto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:49:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41133 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1DNRtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bjGJUMUEAdpbLzVpZP5knmp4Pijy9jZR8yMQVEdg92DJdAsPh9mDNAgNgFDAclY/rr
         oFLRH6vw2Zo0cWTcSKgXRancfrobV+1XAwb/pcwqtPoYQza659SApws54nJ9PzFWahlu
         AT6gcGy30Gn5+nsikOMYqSOs1HKP7IPArI4+M=
Message-ID: <4DA733B1.1010702@gmail.com>
Date: Thu, 14 Apr 2011 21:49:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
References: <4DA70950.3060102@openvz.org> <20110414174327.GA8863@elte.hu> <20110414174420.GA8950@elte.hu>
In-Reply-To: <20110414174420.GA8950@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 09:44 PM, Ingo Molnar wrote:
> 
> below is the commit which needs to be fixed - note that i improved the 
> changelog, please keep these fixes for future submissions.
> 
> Thanks,
> 
> 	Ingo
> 

Yes, thanks, i'll ping back as only get nit resolved.

-- 
    Cyrill
