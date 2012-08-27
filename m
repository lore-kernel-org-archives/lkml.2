Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2H0Szd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:55:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab2H0Szc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:55:32 -0400
Message-ID: <503BC298.3080306@redhat.com>
Date: Mon, 27 Aug 2012 11:55:20 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michael Wolf <mjw@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, glommer@parallels.com, mingo@redhat.com
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
References: <20120823231346.11681.1502.stgit@lambeau>
In-Reply-To: <20120823231346.11681.1502.stgit@lambeau>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 04:14 PM, Michael Wolf wrote:
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
> This patchset is changing the contents/output of /proc/stat and could affect 
> user tools.  However the default setting is that the cpu is entitled to 100% 
> so the code will act as before.  Also another field could be added to the 
> /proc/stat output and show the unaltered steal time. Since this additional 
> field could cause more confusion than it would clear up I have left it out 
> for now.
>                 

How would a guest know what its entitlement is?


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

