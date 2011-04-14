Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146Ab1DNPGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:06:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52197 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130Ab1DNPGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=C3I9v74gSxgEnXUVAq/S8bGYDjMDfpCzwgNgTwXDFkoNh06XtLO8r7lJwBNf8+tkpO
         AkUfGVuoKa36pVoKfT2B9IKbUqvrbF6O90J1sLyIJZYHAOLP+isvl7Nmo7Qa3aXllMDr
         LTXrXh76TrdETePGvCeGGZjDGke8UNrGzDgfc=
Message-ID: <4DA70D60.8080103@openvz.org>
Date: Thu, 14 Apr 2011 19:06:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
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
References: <4DA70950.3060102@openvz.org> <20110414150351.GA5295@elte.hu>
In-Reply-To: <20110414150351.GA5295@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 07:03 PM, Ingo Molnar wrote:
> 
> Cyrill,
> 
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
>> From: Don Zickus <dzickus@redhat.com>
>> Subject: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
> ...
>> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
> 
> When forwarding patches please always use Signed-off-by, not Acked-by - 
> especially when you also edit the patch slightly.
> 
> Is it fine to you if i add your SOB to this patch?
> 
> Thanks,
> 
> 	Ingo

Of course I'm fine! Sorry Ingo for inconvenience.

-- 
    Cyrill
