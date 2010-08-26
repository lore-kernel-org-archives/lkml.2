Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0HZJSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:18:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58221 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab0HZJSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VeHfEL8+O+UFzIZh1AQLD+3AsnMXA6H//J/ppGJHif/Ruf3CFa6JESQijFtd9fiU/c
         BNLhLq8Ws9hRZFUIMiJNRepsjGxt13QjB4XRiK8uVDrk+UMrk+V1JzmAs21WiIRLXjnn
         y/IRloLA2aIsSqBA/AQ61dZXhhHSlbciObOF0=
MIME-Version: 1.0
In-Reply-To: <20100826090008.GA22783@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
	<20100820152510.GA4167@elte.hu>
	<20100825094819.GB3198@erda.amd.com>
	<20100825104130.GA27891@elte.hu>
	<20100825110006.GB27891@elte.hu>
	<20100825201106.GH4879@redhat.com>
	<20100826090008.GA22783@erda.amd.com>
Date: Thu, 26 Aug 2010 13:18:29 +0400
Message-ID: <AANLkTim3+u-fV-RAC=Odede6BfGdYoXsN55Tqw6iSfVT@mail.gmail.com>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running perfctrs
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 1:00 PM, Robert Richter <robert.richter@amd.com> wrote:
...
>
> This could also be a race in the counter handling code, or we do not
> proper count the number of handled counters. Maybe 2 counters actually
> fired but we only noticed one counter and then accidentially cleared
> the 2nd without processing it.
>
> -Robert
>

Any chance to get it tested on P4 machine since it has a bit
different design?

Cyrill
