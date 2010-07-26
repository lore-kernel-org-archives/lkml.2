Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0GZK2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:28:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43859 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab0GZK17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bXcqTrSs8ndiy/JwrTF2/Z0XM4iNeMPgiPZukiJ99A5GbcwX9OBJyo3pSpRy9BOjto
         K9NE9yt1tWdQBD2V+gt/O7KOmX8J+xqz0F0QzN0lQk301+3LY9VqvUWU5WhmLq5EmcLB
         w1KJp3ytCKMafvrohydna1ANOcuDM00Z9c6Fs=
MIME-Version: 1.0
In-Reply-To: <20100726120519.2EFA.A69D9226@jp.fujitsu.com>
References: <20100726120107.2EEE.A69D9226@jp.fujitsu.com>
	<20100726120519.2EFA.A69D9226@jp.fujitsu.com>
Date: Mon, 26 Jul 2010 15:57:58 +0530
X-Google-Sender-Auth: h95jzv0DFi8fiGHM3n3-vtt4J34
Message-ID: <AANLkTimJ0NrT6M39UJvPd_X0YcEsCax6BCOQfqLdiopE@mail.gmail.com>
Subject: Re: [PATCH 4/4] memcg: add mm_vmscan_memcg_isolate tracepoint
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

On Mon, Jul 26, 2010 at 8:36 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Memcg also need to trace page isolation information as global reclaim.
> This patch does it.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir
