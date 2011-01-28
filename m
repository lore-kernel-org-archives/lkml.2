Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1A1BbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:31:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:62579 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1A1BbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=epBRV/crLRkyZPH94/HzIREyNCrJ9wrvU1qACYFwQ1Q2ORinXRLGBilGf7rv9GR0fa
         6/vDc9l7RrWV6CnUtzWQ==
MIME-Version: 1.0
In-Reply-To: <4D42192C.9000701@codeaurora.org>
References: <AANLkTi=6nwDCdzDz7E2EaAw2pf3KUVjmKMRqGfz5zVhP@mail.gmail.com>
 <1290577024-12347-1-git-send-email-ccross@android.com> <4D42192C.9000701@codeaurora.org>
From: Paul Menage <menage@google.com>
Date: Thu, 27 Jan 2011 17:30:41 -0800
Message-ID: <AANLkTin7B51maXHRH+FNmZ14bmWmEp9P2=2QTNqgq_Fi@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroup: Set CGRP_RELEASABLE when adding to a cgroup
To: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Colin Cross <ccross@android.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mbohan@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 5:17 PM, Bryan Huntsman <bryanh@codeaurora.org> wrote:
>
> Tested-by: Mike Bohan <mbohan@codeaurora.org>
>
> I'm responding on Mike's behalf and adding him to this thread.  This
> patch improves launch time of a test app from ~700ms to ~250ms on MSM,
> with much lower variance across tests.  We also see UI latency
> improvements, but have not quantified the gains.
>

Is this attached to the wrong patch? I'd thought that it was the other
patch (removing the rcu_synchronize()) that's the performance booster.
This one is more about preserving the semantics of the notification
API.

Paul
