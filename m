Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2E3MKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:10:19 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54697 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab2E3MKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:10:17 -0400
Message-ID: <4FC60D9D.8080705@parallels.com>
Date: Wed, 30 May 2012 16:07:57 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Paul Turner <pjt@google.com>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        <handai.szj@gmail.com>, <Andrew.Phillips@lmax.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 4/6] add a new scheduler hook for context switch
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>  <1338371317-5980-5-git-send-email-glommer@parallels.com> <1338376851.26856.260.camel@twins>
In-Reply-To: <1338376851.26856.260.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 03:20 PM, Peter Zijlstra wrote:
> /me cries a little.. I was hoping to fix put_prev_task.. see:
>
>    https://lkml.org/lkml/2012/2/16/487
>
> (I've actually got a 4 patch split out of that if anybody cares)
>
> Its just one of those things stuck behind the -ENOTIME tree :/
>
> The plan is to 'merge' put_prev_task and pick_next_task into one and
> avoid a lot of the up-down walking.
>
> You just added a constraint for always having to walk the entire thing
> up -- cgroups is too damn expensive already, we should be trimming this
> nonsense not bloating it.

if they are merged, then I don't need a new hook.

Do you have plans to do it? I'd be happy to continue the work if you 
lack the time, since I am directly interested in the functionality.


