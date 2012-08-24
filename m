Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab2HXE4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 00:56:45 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39544 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2HXE4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 00:56:42 -0400
Message-ID: <503708C8.2090401@parallels.com>
Date: Fri, 24 Aug 2012 08:53:28 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michael Wolf <mjw@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <peterz@infradead.org>, <mtosatti@redhat.com>, <mingo@redhat.com>,
        <avi@redhat.com>
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
References: <20120823231346.11681.1502.stgit@lambeau>
In-Reply-To: <20120823231346.11681.1502.stgit@lambeau>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [193.189.68.173]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 03:14 AM, Michael Wolf wrote:
> This is an RFC regarding the reporting of stealtime.  In the case of
> where you have a system that is running with partial processors such as
> KVM the user may see steal time being reported in accounting tools such
> as top or vmstat.  This can cause confusion for the end user.  To
> ease the confusion this patch set adds a sysctl interface to set the
> cpu entitlement.  This is the percentage of cpu that the guest system is
>  expected to receive.  As long as the steal time is within its expected
> range it will show up as 0 in /proc/stat.  The user will then see in the
> accounting tools that they are getting a full utilization of the cpu
> resources assigned to them.
> 

And how is such a knob not confusing?

Steal time is pretty well defined in meaning and is shown in top for
ages. I really don't see the point for this.
