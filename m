Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143Ab2JSPk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:40:26 -0400
Received: from relay.parallels.com ([195.214.232.42]:47767 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759088Ab2JSPkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:40:24 -0400
From: Vladimir Davydov <VDavydov@parallels.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@redhat.com>, Paul Turner <pjt@google.com>,
        Kirill Korotaev <dev@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Date: Fri, 19 Oct 2012 19:40:20 +0400
Subject: Re: [PATCH RFC] sched: boost throttled entities on wakeups
Thread-Topic: [PATCH RFC] sched: boost throttled entities on wakeups
Thread-Index: Ac2uEArp2gwmuwh+QliO/ilns7etqA==
Message-ID: <109B1FB1-8832-49B8-AD3E-2C7176946DE5@parallels.com>
References: <206EF0C3-1F5F-4B58-B7DA-E63298939DFD@parallels.com>
 <1350656690.2768.19.camel@twins>
In-Reply-To: <1350656690.2768.19.camel@twins>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the answer.

On Oct 19, 2012, at 6:24 PM, Peter Zijlstra wrote:

> its a quick hack similar to existing hacks done for rt, preferably we'd
> do smarter things though.

If you have any ideas how to fix this in a better way, please share.

