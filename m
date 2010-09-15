Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0IOR3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:29:02 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33353 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab0IOR3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:29:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ILWvaIOf1aAy64fMjKa09h0/rYjQQETPjALVSxXa/XPswztUZLb4KWOXSKLppOvhs4
         NPrHGopILj6lNvgLxs97knAfHhGeBqIbT0bmn2vbzEZHDK2y3xCkrHCBlzS2mAdzRdnZ
         YejkIbLbYvXhbSMjOf78ArEiwbpW89Ascx9BQ=
MIME-Version: 1.0
In-Reply-To: <20100915124831.GB27658@esdhcp04044.research.nokia.com>
References: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<AANLkTi=RsA0tACWOg+8RTSuDHwa4LGOiyO-4TxpJ_rb5@mail.gmail.com>
	<20100915124831.GB27658@esdhcp04044.research.nokia.com>
Date: Wed, 15 Sep 2010 10:28:59 -0700
X-Google-Sender-Auth: TpaZ-syahW8bzGLqCw28tGwLrFg
Message-ID: <AANLkTi=hPcXC1=Lrey1H_UHRJRJ-NdTsvmyxgP_n+dM8@mail.gmail.com>
Subject: Re: [PATCH 0/2] ia64: possible module unwind table optimisation
From: Tony Luck <tony.luck@intel.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 5:48 AM, Phil Carmody
<ext-phil.2.carmody@nokia.com> wrote:
>>   for (table = unw.tables; table; table = table->next)
>>
>> before we find the right table to look?
>
> Yes, that's the one. Sorry I wasn't more explicit.

My usual workload (building new Linux kernels - what else :-) doesn't
seem to generate
any unwind requests.  I reached the loop just 58 times while booting,
and only did 23
steps past the first item [didn't track a histogram, so I don't know
whether that was a
single 23 step lookup, or 23 one-step ones].  Building the kernel
(make -j32) didn't add
to either count.

Workload ideas?

-Tony
