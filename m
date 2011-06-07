Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1FGMTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:19:42 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:47171 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab1FGMTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:19:41 -0400
Message-ID: <4DEE1753.2060307@free.fr>
Date: Tue, 07 Jun 2011 14:19:31 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>
Subject: Re: [Patch] doc: remove ns_cgroup from feature-removal-schedule.txt
References: <20110607120630.GA3550@cr0>
In-Reply-To: <20110607120630.GA3550@cr0>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 02:06 PM, Américo Wang wrote:
> In the following commit Daniel removed ns_cgroup
>
> 	commit a77aea92010acf54ad785047234418d5d68772e2
> 	Author: Daniel Lezcano<daniel.lezcano@free.fr>
> 	Date:   Thu May 26 16:25:23 2011 -0700
>
> 	    cgroup: remove the ns_cgroup
>
> but Daniel forgot to remove the related doc in feature-removal-schedule.txt.
> This patch removes that too.

Well, I am not sure we should remove this entry from the documentation.
I let this in the doc because people may want to follow what was removed 
and from what kernel version.
Looking at the doc, there are a lot of old entries.
