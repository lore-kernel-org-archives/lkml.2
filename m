Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474Ab2CMKKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:10:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760153Ab2CMKK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:10:26 -0400
Message-ID: <4F5F1D0D.8080408@redhat.com>
Date: Tue, 13 Mar 2012 12:10:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Davidlohr Bueso <dave@gnu.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: add tracepoint for vpids
References: <1331481472.17316.1.camel@offbook> <4F5DB245.9060205@redhat.com> <1331551781.1334.3.camel@offworld> <4F5DD140.7040605@redhat.com> <1331636285.12394.4.camel@offworld>
In-Reply-To: <1331636285.12394.4.camel@offworld>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 12:58 PM, Davidlohr Bueso wrote:
> On Mon, 2012-03-12 at 12:34 +0200, Avi Kivity wrote:
> > On 03/12/2012 01:29 PM, Davidlohr Bueso wrote:
> > > On Mon, 2012-03-12 at 10:22 +0200, Avi Kivity wrote:
> > > > On 03/11/2012 05:57 PM, Davidlohr Bueso wrote:
> > > > > From: Davidlohr Bueso <dave@gnu.org>
> > > > >
> > > > > Add a new tracepoint for vpid allocation and freeing associated to all vCPUs.
> > > > >
> > > > 
> > > > Why?
> > > > 
> > >
> > > We have been using this tracepoint for some time now to help debug vpids
> > > and simulating tagged TLB behavior and performance. This gets to be non
> > > trivial when working with large amounts of guests and vCPUs.
> > 
> > I don't follow.  Can you give an example of when this tracepoint would
> > be useful?
> > 
>
> For example when running lots of guests with many different hardware
> configurations (ept on/off, vpid on/off) I trace what vcpu has or
> doesn't have a corresponding vpid associated. Perhaps this is more
> useful for experimental things than actual KVM development.

So it seems.  Tracepoints should be useful for production deployments,
not development.

-- 
error compiling committee.c: too many arguments to function

