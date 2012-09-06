Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab2IFLck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:32:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab2IFLcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:32:35 -0400
Message-ID: <504889C9.6060706@redhat.com>
Date: Thu, 06 Sep 2012 14:32:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v2 PATCH 01/21] x86: Split memory hotplug function from
 cpu_up() as cpu_memory_up()
References: <20120906112718.13320.8231.stgit@kvmdev> <20120906112723.13320.29299.stgit@kvmdev> <504889A6.3030904@redhat.com>
In-Reply-To: <504889A6.3030904@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 02:31 PM, Avi Kivity wrote:
> On 09/06/2012 02:27 PM, Tomoki Sekiyama wrote:
>> Split memory hotplug function from cpu_up() as cpu_memory_up(), which will
>> be used for assigning memory area to off-lined cpus at following patch
>> in this series.
>> 
> 
> Can post a summary containing both the general outline for people
> reading this for the first time, or who have forgotten it, and the list
> of changes from v1?
> 

Never mind, I see it was posted, just that I wasn't copied on it.

-- 
error compiling committee.c: too many arguments to function
