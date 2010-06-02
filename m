Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0FBF0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:26:38 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37007 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab0FBF0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:26:37 -0400
Date: Wed, 2 Jun 2010 10:56:32 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100602052632.GA25864@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20100601093515.GH24302@redhat.com>
 <87sk56ycka.fsf@basil.nowhere.org>
 <20100601162414.GA6191@redhat.com>
 <20100601163807.GA11880@basil.fritz.box>
 <4C053ACC.5020708@redhat.com>
 <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C05C722.1010804@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 05:51:14AM +0300, Avi Kivity wrote:
> That's definitely the long term plan.  I consider Gleb's patch the
> first step.
> 
> Do  you have any idea how we can tackle both problems?

I recall Xen posting some solution for a similar problem:

http://lkml.org/lkml/2010/1/29/45

Wouldn't a similar approach help KVM as well?

- vatsa
