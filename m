Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0ISLFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 07:05:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab0ISLFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 07:05:13 -0400
Message-ID: <4C95EE65.3090209@redhat.com>
Date: Sun, 19 Sep 2010 13:05:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
References: <20100916135137.GB24850@redhat.com> <20100916140615.GJ3008@redhat.com> <20100916142335.GC24850@redhat.com> <20100916145117.GK3008@redhat.com> <20100916152411.GE24850@redhat.com> <20100916154326.GL3008@redhat.com> <20100916220715.GA30531@redhat.com> <20100917075929.GA11518@redhat.com> <20100919104550.GA7350@redhat.com> <4C95EC4C.4060904@redhat.com> <20100919105512.GB7350@redhat.com>
In-Reply-To: <20100919105512.GB7350@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/19/2010 12:55 PM, Michael S. Tsirkin wrote:
> On Sun, Sep 19, 2010 at 12:56:12PM +0200, Avi Kivity wrote:
> >   On 09/19/2010 12:45 PM, Michael S. Tsirkin wrote:
> >  >On Fri, Sep 17, 2010 at 09:59:29AM +0200, Gleb Natapov wrote:
> >  >>   >   writing 0 to eventfd does nothing. The way to deassert irq
> >  >>   That is implementation detail of current irqfd. It was designed for MSI
> >  >>   not level triggered interrupts.
> >  >
> >  >Maybe we should add a check that gsi is mapped to MSI (or unmapped) then?
> >  >Level which switches to 1 and back to 0 immediately will be racy anyway
> >  >...
> >  >
> >
> >  Add a check where?
>
> I would make sure that if you bind irqfd to a non-MSI GSI,
> signalling it has no effect.
>

Certainly.  We should also update the documentation, when we have irqfd 
documentation.

-- 
error compiling committee.c: too many arguments to function

