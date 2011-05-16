Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1EPJtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:49:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1EPJtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hQp1YgdovbYmMj5xxb+XHWYIE67vdTRFAQu/QC/D8h6m01Jg44uoHw1kyrtMuCxv4e
         EcpGDgYhplXHuUvHbz6sWIG/ayTP8uM9euo0qR0xMwskzBSY7TiFMGTJIQQDjGmGUfcl
         ArVK95naOCDd7gRd8mBVj/c8F1+/+auQxp69Q=
MIME-Version: 1.0
In-Reply-To: <20110516090355.GA12325@elte.hu>
References: <20110513180449.562138524@sbsiddha-MOBL3.sc.intel.com>
	<20110513181008.859892593@sbsiddha-MOBL3.sc.intel.com>
	<20110516080844.GC27635@elte.hu>
	<BANLkTimAYf1BBAqDpVbc9jRWtfHcg2SbNQ@mail.gmail.com>
	<20110516090355.GA12325@elte.hu>
Date: Mon, 16 May 2011 13:48:59 +0400
X-Google-Sender-Auth: igWwKy0oY0MzNagWfbk-Sr_S5Fg
Message-ID: <BANLkTimgcr_yzkwYscBFyopt-96sJfr-Fg@mail.gmail.com>
Subject: Re: [patch 1/5] x84_64, apic: Use probe routines to simplify apic selection
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "steiner@sgi.com" <steiner@sgi.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, thanks Ingo.

On Monday, May 16, 2011, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>
>>   Yes, this should be a cleaner step but it requires some more code churn
>> that is why I think Suresh' approach is pretty well done! Ingo, probably we
>> could do so on *top* of this changes as only time permits? The problem is
>> that I personally can't guarantee I continue working on the task this week,
>> if Suresh is able to -- this would be great, if not -- probably even such
>> minimal disturbing patch worth merging, it definitley makes code better I
>> think ;)
>
> We can do it on top, but within the series please. The APIC mess is not
> improving so we only want to merge features that are done cleanly.
>
> Thanks,
>
>         Ingo
>
