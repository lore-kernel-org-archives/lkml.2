Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab0KRNjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:39:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868Ab0KRNjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:39:24 -0500
Message-ID: <4CE52C83.4090007@redhat.com>
Date: Thu, 18 Nov 2010 15:39:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
References: <20101117221254.GA8296@redhat.com> <20101118105741.GA31261@redhat.com> <4CE50810.3090502@redhat.com> <20101118111037.GB31261@redhat.com> <4CE51C17.4000108@redhat.com> <20101118130337.GA2254@redhat.com> <20101118131453.GO7948@redhat.com> <20101118132027.GB8247@redhat.com> <20101118133501.GQ7948@redhat.com>
In-Reply-To: <20101118133501.GQ7948@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 03:35 PM, Gleb Natapov wrote:
> >
> >  or something like this.
> Ah so you want to do it only for MSI? For MSI it makes sense. Remember
> though that sometimes destination depend on message itself (specifically
> on delivery mode).

Yes, broadcast or multicast or lowest priority wouldn't get this treatment.

-- 
error compiling committee.c: too many arguments to function

