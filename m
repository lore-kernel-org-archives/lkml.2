Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284Ab2CMJ5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:57:41 -0400
Received: from damascus.uab.es ([158.109.168.135]:62614 "EHLO damascus.uab.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965083Ab2CMJ5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:57:39 -0400
Date: Tue, 13 Mar 2012 11:58:05 +0100
From: Davidlohr Bueso <dave@gnu.org>
Subject: Re: [PATCH] KVM: VMX: add tracepoint for vpids
In-reply-to: <4F5DD140.7040605@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Message-id: <1331636285.12394.4.camel@offworld>
Organization: GNU
MIME-version: 1.0
X-Mailer: Evolution 3.0.3-2
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-Spam-Tests: ALL_TRUSTED=-1
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18770.005)
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:3 C:3 M:3 S:3 R:3 (0.5000 0.5000)
References: <1331481472.17316.1.camel@offbook> <4F5DB245.9060205@redhat.com>
 <1331551781.1334.3.camel@offworld> <4F5DD140.7040605@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 12:34 +0200, Avi Kivity wrote:
> On 03/12/2012 01:29 PM, Davidlohr Bueso wrote:
> > On Mon, 2012-03-12 at 10:22 +0200, Avi Kivity wrote:
> > > On 03/11/2012 05:57 PM, Davidlohr Bueso wrote:
> > > > From: Davidlohr Bueso <dave@gnu.org>
> > > >
> > > > Add a new tracepoint for vpid allocation and freeing associated to all vCPUs.
> > > >
> > > 
> > > Why?
> > > 
> >
> > We have been using this tracepoint for some time now to help debug vpids
> > and simulating tagged TLB behavior and performance. This gets to be non
> > trivial when working with large amounts of guests and vCPUs.
> 
> I don't follow.  Can you give an example of when this tracepoint would
> be useful?
> 

For example when running lots of guests with many different hardware
configurations (ept on/off, vpid on/off) I trace what vcpu has or
doesn't have a corresponding vpid associated. Perhaps this is more
useful for experimental things than actual KVM development.



