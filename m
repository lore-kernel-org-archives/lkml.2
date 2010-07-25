Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab0GYI2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:28:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46055 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0GYI2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:28:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=N8Mghq4V94z5ICzOoc3zFwpOtSEp1zTHpYQEn2gmMmxfF1qByMLV5K+f0bSVGdZ07O
         yXaK/Xsti57dZFJkW7iyoI9utfYJ375uqVcIEflxxHx24bZafgvOKyUKTajdWsBQL4FD
         Tm8k7fodspe2gqOzXicrFClG4sWRZ5dL91ilM=
MIME-Version: 1.0
In-Reply-To: <20100723141111.88A8.A69D9226@jp.fujitsu.com>
References: <20100716191334.736F.A69D9226@jp.fujitsu.com>
	<20100722044911.GK14369@balbir.in.ibm.com>
	<20100723141111.88A8.A69D9226@jp.fujitsu.com>
Date: Sun, 25 Jul 2010 13:58:42 +0530
X-Google-Sender-Auth: MXPUtU8unSkrnl-BRLewIqoCzF4
Message-ID: <AANLkTi=wFkujwaMYrREJ1=sop_CZAsX2Nc7kcC3nji-t@mail.gmail.com>
Subject: Re: [PATCH 2/7] memcg: mem_cgroup_shrink_node_zone() doesn't need 
	sc.nodemask
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> We need the initialization to 0, is there a reason why it was removed?
>
> please reread C spec and other scan_control user.
> sc_nr_* were already initialized in struct scan_control sc = { } line.
>

I missed the fact that  designated initializers do the right thing. Thanks!

Balbir
