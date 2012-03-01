Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab2CART1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:19:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab2CARTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:19:25 -0500
Message-ID: <4F4FAF89.3090706@redhat.com>
Date: Thu, 01 Mar 2012 18:19:05 +0100
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
References: <20120221211938.GE12236@google.com>  <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>  <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>
In-Reply-To: <1330006399.11248.20.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 23.2.2012 15:13, Peter Zijlstra napsal:
> My utter disregard for cgroups comes from having to actually implement a
> controller for them, its a frigging nightmare. The systemd retards
> mandating all this nonsense for booting a machine is completely bonghit
> inspired and hasn't made me feel any better about it.

systemd requires only CONFIG_CGROUPS=y. It does not need any controllers.

The insults are entirely unnecessary.

Michal
