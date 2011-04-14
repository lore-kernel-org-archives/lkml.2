Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab1DNPXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:23:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46413 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1DNPXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:23:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pi4NiLNIApeILdOw+B/f4SNtRG/1KOKnXVsemB0z497DzQC4dpnFCAeSZJPX15uR8h
         SpsBmoWoAaZis3F/NZ/W34D369exDTeth+VLeifk6R5ZRb6BMiefH5HpEJtIbXL3SZBA
         29eMyZ3Gh3gfDRI+5xGJrNRuUc/J/K+aQTGH4=
Message-ID: <4DA71150.5090103@gmail.com>
Date: Thu, 14 Apr 2011 19:22:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: a.p.zijlstra@chello.nl, airlied@gmail.com, dzickus@redhat.com,
        eranian@google.com, linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
        sruffell@digium.com
Subject: Re: Uhhuh. NMI received for unknown reason 2d on CPU 0.
References: <20110414151601.675.qmail@science.horizon.com>
In-Reply-To: <20110414151601.675.qmail@science.horizon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 07:16 PM, George Spelvin wrote:
>> George, mind to give these patches a shot please? (Sorry for sending
>> it as attachment).
> 
> It ran overnight with no problems.  (Well, I'm having a problem with udev
> using 100% of CPU, but that appears to be unrelated.)
> 
> Thank you very much!
> 
> Acked-By: George Spelvin <linux@horizon.com>

Thanks a lot for testing! Kudo goes to Don :)

-- 
    Cyrill
