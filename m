Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab0KRNth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:49:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899Ab0KRNtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:49:35 -0500
Date: Thu, 18 Nov 2010 15:49:21 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
Message-ID: <20101118134921.GD8247@redhat.com>
References: <20101117221254.GA8296@redhat.com>
 <20101118105741.GA31261@redhat.com>
 <4CE50810.3090502@redhat.com>
 <20101118111037.GB31261@redhat.com>
 <4CE51C17.4000108@redhat.com>
 <20101118130337.GA2254@redhat.com>
 <20101118131453.GO7948@redhat.com>
 <20101118132027.GB8247@redhat.com>
 <20101118133501.GQ7948@redhat.com>
 <4CE52C83.4090007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE52C83.4090007@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:39:15PM +0200, Avi Kivity wrote:
> On 11/18/2010 03:35 PM, Gleb Natapov wrote:
> >>
> >>  or something like this.
> >Ah so you want to do it only for MSI? For MSI it makes sense. Remember
> >though that sometimes destination depend on message itself (specifically
> >on delivery mode).
> 
> Yes, broadcast or multicast or lowest priority wouldn't get this treatment.

Unless there's a single online VCPU :)

> -- 
> error compiling committee.c: too many arguments to function
