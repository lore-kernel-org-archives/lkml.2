Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab1DMUxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:53:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47327 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab1DMUxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fa+Ep8Z4qX75/JCADIMaWqtt5KxcQVHxqTQOUhWb7xPXa6bTeQFXAMzloKOuVuJ6jb
         dw7EDuEzf2bNZ/fLAHs4B45U3iJn7emqgqvXCp7q0uil1iBQCbs/DVrOZqyGvrJvQJk0
         rqf2wKYn/XWiJLQOyooo4Cp1S7MDD8h4TiFHU=
Message-ID: <4DA60B03.30603@openvz.org>
Date: Thu, 14 Apr 2011 00:43:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Shaun Ruffell <sruffell@digium.com>
CC: maciej.rutecki@gmail.com, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper
 MSR register to catch" and NMIs
References: <20110406223036.GA15721@digium.com> <201104132133.51958.maciej.rutecki@gmail.com> <4DA6011F.7070405@openvz.org> <20110413203501.GA10744@digium.com>
In-Reply-To: <20110413203501.GA10744@digium.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 12:35 AM, Shaun Ruffell wrote:
...
> 
> I had the first version of the patch running the test builds all night without
> any NMIs. I installed this one and ran it through the case where I would
> reliably get early NMIs and it still no NMIs.
> 
> So for v2:
> Tested-by: Shaun Ruffell <sruffell@digium.com>
> 
> Thanks!

Thanks a huge Shaun. The thing is (if only I don't miss something) at moment there is
no much difference in which patch to pick up. But as only kgdb dives in or any other
subsystem (which say would use same manner of nmi delivery) we might be unmasking
lvt entry even if nothing were handled at all, so I bias to a second version.

-- 
    Cyrill
