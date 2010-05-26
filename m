Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab0EZHoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:44:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:22381 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab0EZHod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pxIR2B7NJUZuQIh2uoKqJH1zYB9lRq/kmJkTi/dUnB0Ke7R6zsMWGL4MMb76uXXiW0
         jFVp8pu+1e2qoR5bDxwnz9u6TDZWXt6WfMac7MvDElUQAIoQ4E0wyvMLcwe9lNXbQZ2f
         408Kh8876XzQCtcZpNZERojQUwWbI2BKede+g=
MIME-Version: 1.0
In-Reply-To: <4BFCCBB0.6040101@cn.fujitsu.com>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
	<20100525201259.GA5370@nowhere>
	<AANLkTinuHB9gPLBZs_QsHqOm6Y5nR91P_gFlVBXa-ilJ@mail.gmail.com>
	<4BFCCBB0.6040101@cn.fujitsu.com>
Date: Wed, 26 May 2010 10:44:31 +0300
X-Google-Sender-Auth: 5Nq8EHfi759T00KjRd_0Pc5AAsM
Message-ID: <AANLkTimShgg7ACQ53n3lAMNj6OwwJHXHXEKM7KE_HbRL@mail.gmail.com>
Subject: Re: Tracing configuration review
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Chase Douglas <chase.douglas@canonical.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 10:20 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> That said, I was probably the only one actually using the feature so
>> maybe we can just nuke kmemtrace at this point...
>
> If you agree on removing kmemtrace now, I'll re-send the patch.

Sounds good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
