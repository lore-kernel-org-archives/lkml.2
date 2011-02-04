Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1BDEQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 23:16:07 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:56498 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1BDEQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 23:16:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BxKUZIdDXJ5AKZt0YZCLWtbEsyRnqC2dm8yK1N4sCEntd6hblzagYpBVb3SSrsm1Hv
         v9gSe60iw5ph5pyHE7TOIorvIkvPtElcLfyTnqxHAXM+HBOYnEm8m7s3z/sDIw/2ikcy
         wX+gHuKSBwNpBpjGzY7EMsWhVUdMEEKwY3B4M=
MIME-Version: 1.0
In-Reply-To: <1296743166-9412-2-git-send-email-hannes@cmpxchg.org>
References: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
	<1296743166-9412-2-git-send-email-hannes@cmpxchg.org>
Date: Fri, 4 Feb 2011 09:46:05 +0530
X-Google-Sender-Auth: A19ISu6b16cUgivj6dkIJXdTkRc
Message-ID: <AANLkTim584=bgyoRux18C=yNniAdof28=xLxS+vnaApT@mail.gmail.com>
Subject: Re: [patch 1/5] memcg: no uncharged pages reach page_cgroup_zoneinfo
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 7:56 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> All callsites check PCG_USED before passing pc->mem_cgroup, so the
> latter is never NULL.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
