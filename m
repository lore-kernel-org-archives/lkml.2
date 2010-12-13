Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab0LMJqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:46:49 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:43072 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab0LMJqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:46:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NrKVwgfVWlS9aluDOVDWvE6V1ckaXaZ6frdasCu1jQdk0yDY3/GRnOCKa75GCY+mp3
         dSW0eZoXtRygFOKy1b9J3NN2CEt6Yf8tM05XreEplhB4oB1AnZs3ntipy2h5KifKg+Pj
         ROsxOIHX+YvSS3YD10ikbLHDQ431hJttjrtEI=
Message-ID: <4D05EBA4.60202@gmail.com>
Date: Mon, 13 Dec 2010 10:47:16 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
References: <1291255347.12777.116.camel@sli10-conroe> <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe>
In-Reply-To: <1292200886.2323.15.camel@sli10-conroe>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/13/2010 01:41 AM, Shaohua Li wrote:
>> Why add another set of macros?  Can't you just make the default one
>> aligned?
> how to do it without changing all arch code? There isn't cache line size
> macro for all arch which could be used in vmlinux.lds.h, IIRC.

Can't we get around that with some ifdefferies?  And even if we'll
have to change lds on every arch, I think we better do it that way.
It's not like the problem exists only on x86, right?

Thanks.

-- 
tejun
