Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1BDEKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 23:10:06 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:35747 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1BDEKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 23:10:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wDvgaMRt8FpMnoz3OxESrzZJrSfTXtw932R0ewoPBwTdsH4hNrSs+n+oKveMtlTFrA
         mOcKjel43kCA6EIWh80GspNCo2oXL4TaeNTehtjXmuLrRsqcoVgTYHYHBs2naa700YsA
         GqMLmjlFYr/i5KxWqphdBh9Y5LneFXRRIGusQ=
MIME-Version: 1.0
In-Reply-To: <20110203125453.GB2286@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
	<1296482635-13421-3-git-send-email-hannes@cmpxchg.org>
	<20110131144131.6733aa3a.akpm@linux-foundation.org>
	<20110201000455.GB19534@cmpxchg.org>
	<20110131162448.e791f0ae.akpm@linux-foundation.org>
	<20110203125357.GA2286@cmpxchg.org>
	<20110203125453.GB2286@cmpxchg.org>
Date: Fri, 4 Feb 2011 09:40:04 +0530
X-Google-Sender-Auth: kuJhthQ2Ej45jFaKMEPAPDFodoc
Message-ID: <AANLkTi=Rex6rGYgBwnmnV66oZ_Vs21FOvjU-v=h0g6ZH@mail.gmail.com>
Subject: Re: [patch 1/2] memcg: soft limit reclaim should end at limit not below
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com,
        nishimura@mxp.nes.nec.co.jp, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 6:24 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Soft limit reclaim continues until the usage is below the current soft
> limit, but the documented semantics are actually that soft limit
> reclaim will push usage back until the soft limits are met again.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
