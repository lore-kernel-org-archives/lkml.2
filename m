Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab2CBKwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:52:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab2CBKwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:52:03 -0500
Message-ID: <4F50A63F.40306@redhat.com>
Date: Fri, 02 Mar 2012 11:51:43 +0100
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
References: <20120221211938.GE12236@google.com>  <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>  <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>  <4F4FAF89.3090706@redhat.com> <1330633603.7414.49.camel@marge.simpson.net>  <20120301210213.GF13533@redhat.com> <1330639448.7414.97.camel@marge.simpson.net>
In-Reply-To: <1330639448.7414.97.camel@marge.simpson.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 11:04 PM, Mike Galbraith wrote:
> Hm.  Controllers are perhaps not required, but cpu controller was
> configured and used without consent.  I didn't receive an offer.

This is optional.

"DefaultControllers=" in /etc/systemd/system.conf
