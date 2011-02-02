Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1BBKPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:15:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab1BBKPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:15:02 -0500
Message-ID: <4D492E9C.9040000@redhat.com>
Date: Wed, 02 Feb 2011 12:14:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: Re: [PATCH v2 6/6] Describe KVM_MSR_STEAL_TIME
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>	 <1296244340-15173-7-git-send-email-glommer@redhat.com>	 <4D456555.2030606@redhat.com> <1296575680.5081.14.camel@mothafucka.localdomain>
In-Reply-To: <1296575680.5081.14.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 05:54 PM, Glauber Costa wrote:
> >
> >  The guest must initialize the entire 64-byte structure to zero before
> >  enabling the feature.
>
> I honestly don't see why. But I also don't see why not...
> Will update it.

Requiring the guest to initialize it to zero allows us to later assign 
meanings to various fields, as long as a zero value is backwards compatible.

-- 
error compiling committee.c: too many arguments to function

