Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1CXNXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:23:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab1CXNXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:23:45 -0400
Message-ID: <4D8B45D9.10400@redhat.com>
Date: Thu, 24 Mar 2011 15:23:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mtosatti@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: Enable async page fault processing.
References: <1296559307-14637-1-git-send-email-gleb@redhat.com> <1296559307-14637-3-git-send-email-gleb@redhat.com> <20110324122206.GE32408@redhat.com>
In-Reply-To: <20110324122206.GE32408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 02:22 PM, Gleb Natapov wrote:
> On Tue, Feb 01, 2011 at 01:21:47PM +0200, Gleb Natapov wrote:
> >  If asynchronous hva_to_pfn() is requested call GUP with FOLL_NOWAIT to
> >  avoid sleeping on IO. Check for hwpoison is done at the same time,
> >  otherwise check_user_page_hwpoison() will call GUP again and will put
> >  vcpu to sleep.
> >
> FOLL_NOWAIT is now in Linus tree, so this patch can be applied now. I
> verified that it still applies and works.

Thanks, applied and queued for 2.6.39.

-- 
error compiling committee.c: too many arguments to function

