Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0LJPOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:14:44 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:45343 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab0LJPOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:14:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=N+cDelbX3NfgD06/kmrfBz/ASoBcB8s+YBHC8FzPHeI7aJwjYNYm4tBq5PRHQ1DRRH
         8gIHc4blPvtARhSbiw1vPzmVHWk1gdCc30VSTMGaNcPu6V3AJUPcTQ/J28eOb5oCzKP4
         hA1edT8Vx3n2U628ARy8mDcg/nT5CcRx5T00w=
Message-ID: <4D0243DD.3090507@gmail.com>
Date: Fri, 10 Dec 2010 16:14:37 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        eric.dumazet@gmail.com
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
References: <1291255347.12777.116.camel@sli10-conroe>
In-Reply-To: <1291255347.12777.116.camel@sli10-conroe>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/02/2010 03:02 AM, Shaohua Li wrote:
> percpu readmostly section should start and end at address cachline aligned.
> Idealy we should change PERCPU_VADDR/PERCPU, but I can't change all arch code, so
> I add new macros for x86.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Why add another set of macros?  Can't you just make the default one
aligned?

-- 
tejun
