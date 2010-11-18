Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab0KRLDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:03:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab0KRLDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:03:52 -0500
Message-ID: <4CE50810.3090502@redhat.com>
Date: Thu, 18 Nov 2010 13:03:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
References: <20101117221254.GA8296@redhat.com> <20101118105741.GA31261@redhat.com>
In-Reply-To: <20101118105741.GA31261@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 12:57 PM, Michael S. Tsirkin wrote:
> So the following on top will fix it all.
> Any more comments befpre I bundle it up,
> test and report?
>

Nope (not that I can comment on an incremental).

I guess I should create an empty Documentation/kvm/locking.txt and force 
everyone else to update it.

-- 
error compiling committee.c: too many arguments to function

