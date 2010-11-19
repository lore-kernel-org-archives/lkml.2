Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0KSQ1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:27:47 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62879 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0KSQ1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:27:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=haI3tCLoFxbUUfV5WSyz/NYBZcy6W0UXw/7OWK5tsAsCreix9vuPqmPl6ZYp6dOBC4
         Hf8hrkFQ1Ylw2hyN4nA5X5eNIH+d4+CTUiJgq5a2DAdkDXiGTLFM/ZsySQLZdd1w5dJ9
         pK/s7usYISO6h6dMSHdX6AsjJgQssDZosRxNo=
MIME-Version: 1.0
In-Reply-To: <4CE6A397.6010105@kernel.org>
References: <20101104164401.GC10656@sundance.ccs.neu.edu>
	<4CD3CE29.2010105@kernel.org>
	<20101106053204.GB12449@count0.beaverton.ibm.com>
	<20101106204008.GA31077@sundance.ccs.neu.edu>
	<4CD5D99A.8000402@cs.columbia.edu>
	<20101107184927.GF31077@sundance.ccs.neu.edu>
	<4CD72150.9070705@cs.columbia.edu>
	<4CE3C334.9080401@kernel.org>
	<20101117153902.GA1155@hallyn.com>
	<4CE3F8D1.10003@kernel.org>
	<20101119041045.GC24031@hallyn.com>
	<4CE683E1.6010500@kernel.org>
	<04F4899E-B5C7-4BAF-8F2F-05D507A91408@parallels.com>
	<4CE698C5.5060806@kernel.org>
	<AANLkTikRHuaCpaROtty6X_Oe6JixzgcbVsxHxvtsu+UV@mail.gmail.com>
	<4CE6A076.2020807@kernel.org>
	<AANLkTikz++4_SvqU_Wvx5CjcpKJhPsD7q470swdqwn94@mail.gmail.com>
	<4CE6A397.6010105@kernel.org>
Date: Fri, 19 Nov 2010 18:27:44 +0200
Message-ID: <AANLkTin7kd3crS+fTLLea5PhAii7B3dz=n7p7YtQ6d4g@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kirill Korotaev <dev@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kapil Arya <kapil@ccs.neu.edu>, Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 6:19 PM, Tejun Heo <tj@kernel.org> wrote:
>> The paragon of absurdity is struct task_struct::did_exec .
>
> Yeah, then go and figure how to do that in a way which would be useful
> for other purposes too instead of trying to shove the whole
> checkpointer inside the kernel.  It sure would be harder but hey
> that's the way it is.

System call for one bit? This is ridiculous.
Doing execve(2) for userspace C/R is ridicoulous too (and likely doesn't work).
