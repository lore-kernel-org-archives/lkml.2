Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0I2Rln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:41:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60189 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0I2Rll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sHWRABr+j2efI50ySRKmO+o2ST1D6wDiLqH1m/CFG3j94p6o03pGI1YKT2bPfPntyt
         AVOjurIfW3eeCWztd2Rxym4oQB1Jo9kkwzVVclPHv4B+uwlejg4/s+Vkm1BAXl6rZQUh
         vW4QW3VlBI0HHq2vprTIF23vKmViPwO0Us6Bs=
Date: Wed, 29 Sep 2010 21:41:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
	disabling counters
Message-ID: <20100929174138.GH9440@lenovo>
References: <20100929125453.GH13563@erda.amd.com> <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com> <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com> <20100929150140.GK13563@erda.amd.com> <20100929151253.GL13563@erda.amd.com> <20100929152745.GC9440@lenovo> <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com> <20100929154528.GD9440@lenovo> <AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com> <20100929170924.GR13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929170924.GR13563@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 07:09:24PM +0200, Robert Richter wrote:
> On 29.09.10 12:00:35, Stephane Eranian wrote:
> > But you cannot clear it in x86_pmu_stop() because otherwise it
> > turns into active_mask[]. My understanding is that you need

indeed

  Cyrill
