Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965361Ab2JXVSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:18:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55772 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964884Ab2JXVSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:18:54 -0400
Message-ID: <50885B2E.5050500@linux.vnet.ibm.com>
Date: Wed, 24 Oct 2012 14:18:38 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
References: <20121012125708.GJ10110@dhcp22.suse.cz> <20121023164546.747e90f6.akpm@linux-foundation.org> <20121024062938.GA6119@dhcp22.suse.cz> <20121024125439.c17a510e.akpm@linux-foundation.org> <50884F63.8030606@linux.vnet.ibm.com> <20121024134836.a28d223a.akpm@linux-foundation.org> <20121024210600.GA17037@liondog.tnic>
In-Reply-To: <20121024210600.GA17037@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102421-5518-0000-0000-000008B37BFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 02:06 PM, Borislav Petkov wrote:
> On Wed, Oct 24, 2012 at 01:48:36PM -0700, Andrew Morton wrote:
>> Well who knows. Could be that people's vm *does* suck. Or they have
>> some particularly peculiar worklosd or requirement[*]. Or their VM
>> *used* to suck, and the drop_caches is not really needed any more but
>> it's there in vendor-provided code and they can't practically prevent
>> it.
> 
> I have drop_caches in my suspend-to-disk script so that the hibernation
> image is kept at minimum and suspend times are as small as possible.
> 
> Would that be a valid use-case?

Sounds fairly valid to me.  But, it's also one that would not be harmed
or disrupted in any way because of a single additional printk() during
each suspend-to-disk operation.

