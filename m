Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2CLKer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:34:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab2CLKep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:34:45 -0400
Message-ID: <4F5DD140.7040605@redhat.com>
Date: Mon, 12 Mar 2012 12:34:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Davidlohr Bueso <dave@gnu.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: add tracepoint for vpids
References: <1331481472.17316.1.camel@offbook> <4F5DB245.9060205@redhat.com> <1331551781.1334.3.camel@offworld>
In-Reply-To: <1331551781.1334.3.camel@offworld>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 01:29 PM, Davidlohr Bueso wrote:
> On Mon, 2012-03-12 at 10:22 +0200, Avi Kivity wrote:
> > On 03/11/2012 05:57 PM, Davidlohr Bueso wrote:
> > > From: Davidlohr Bueso <dave@gnu.org>
> > >
> > > Add a new tracepoint for vpid allocation and freeing associated to all vCPUs.
> > >
> > 
> > Why?
> > 
>
> We have been using this tracepoint for some time now to help debug vpids
> and simulating tagged TLB behavior and performance. This gets to be non
> trivial when working with large amounts of guests and vCPUs.

I don't follow.  Can you give an example of when this tracepoint would
be useful?

-- 
error compiling committee.c: too many arguments to function

