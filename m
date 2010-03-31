Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab0CaR5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:57:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949Ab0CaR5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:57:49 -0400
Message-ID: <4BB38D1A.7050204@redhat.com>
Date: Wed, 31 Mar 2010 13:57:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Larry Woodman <lwoodman@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC [Patch] Remove "please try 'cgroup_disable=memory' option
 if you don't want memory cgroups" printk at boot time.
References: <1270049283.3551.281.camel@dhcp-100-19-198.bos.redhat.com> <1270050899.3551.283.camel@dhcp-100-19-198.bos.redhat.com>
In-Reply-To: <1270050899.3551.283.camel@dhcp-100-19-198.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 11:54 AM, Larry Woodman wrote:
> On Wed, 2010-03-31 at 11:28 -0400, Larry Woodman wrote:
>> We are considering removing this printk at boot time from RHEL because
>> it will confuse customers, encourage them to change the boot parameters
>> and generate extraneous support calls.  Its documented in
>> Documentation/kernel-parameters.txt anyway.  Any thoughts???

Yeah, that is a strange boot message...

Acked-by: Rik van Riel <riel@redhat.com>

> OOPS, sorry to attach the patch:
>
>

