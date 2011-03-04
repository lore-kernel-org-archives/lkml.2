Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab1CDMij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:38:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60076 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1CDMii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:38:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EOemiB4vV9GgyWkUpS7lPinnVwbEkkSwNu13uefLD20yGBXmEdAXo3dPcaWaXIjFo0
         84irvAz5bGOkHURYDWsSNsFBegQVl3hhx48hPpqGPZ2eCsz65JCjV5szeDlXRx3JxLqp
         iiAUw4eR5BoM4YJGBWcOoYIHpBnko8KFC/obk=
MIME-Version: 1.0
In-Reply-To: <20110304070802.GA27618@elte.hu>
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org>
	<alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com>
	<20110221083511.GC31267@htj.dyndns.org>
	<alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com>
	<4D700B93.2080807@gmail.com>
	<alpine.DEB.2.00.1103031359070.4141@chino.kir.corp.google.com>
	<4D701015.2040703@kernel.org>
	<alpine.DEB.2.00.1103031404510.4141@chino.kir.corp.google.com>
	<20110304070802.GA27618@elte.hu>
Date: Fri, 4 Mar 2011 15:38:37 +0300
Message-ID: <AANLkTim=ksthQbvmB17Ahw0F718sop9Or5Yh6TuEWwXe@mail.gmail.com>
Subject: Re: [patch] x86, mm: Clean up initmem_init
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        brgerst@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 10:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
...
>>
>> It's a matter of style and I think it's up to Ingo what he'd prefer to
>> see.
>
> I think your variant is cleaner: hiding function call side-effects in conditionscan
> be a fragile thing to do. We want constant expressions with no side-effects - so if
> functions are called they should be constant functions as well.

Well, we do it a lot with say strcmp and others so I would use rather
semantic argument,
but I agree that David's version is easier to read and mark same time
that these functions
are important steps in bootup procedure. So I'm sorry for proposing
this change in first place.

>
> Code compactness isn't everything - if it was we'd be using C to the max to create
> unreadable compound expressions all the time.
>
> Thanks,
>
>        Ingo
>
