Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123Ab2CBL2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:28:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964946Ab2CBL2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:28:20 -0500
Message-ID: <4F50AEC3.5090807@redhat.com>
Date: Fri, 02 Mar 2012 12:28:03 +0100
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
References: <20120221211938.GE12236@google.com>    <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>    <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>   <4F4FAF89.3090706@redhat.com> <1330624986.11248.209.camel@twins>  <4F50AA22.9080007@redhat.com> <1330687394.11248.222.camel@twins>
In-Reply-To: <1330687394.11248.222.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 12:23 PM, Peter Zijlstra wrote:
> On Fri, 2012-03-02 at 12:08 +0100, Michal Schmidt wrote:
>> It's recommended not to do that and nobody actively
>> tests this setup, but at least systemd will not abort. So it can be used
>> to check if the kernel boots and to run some tests.
>
> So you don't recommend people use server type setups? Quality
> engineering that!

I don't follow. Are you saying that CONFIG_CGROUPS=y is incompatible 
with server setups?

Michal
