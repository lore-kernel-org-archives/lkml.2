Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0GZK1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:27:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36964 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab0GZK07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rAwXL9UnQVKhV2wK5KIICdDSaTUZFj0EEONITBnmVvNrlhz4Z44RmfMpUX/QNSnZ/j
         FHXO1iJcZ3TV1MHmWbhSCldKNbpNc8sk5pJz8sIC+4OChToGNxtBm/hWBfUVrTbjfotb
         MNCSbrIC4zM+dxUxyyJvBG0QMI3WW3LNuerCY=
MIME-Version: 1.0
In-Reply-To: <20100726120422.2EF7.A69D9226@jp.fujitsu.com>
References: <20100726120107.2EEE.A69D9226@jp.fujitsu.com>
	<20100726120422.2EF7.A69D9226@jp.fujitsu.com>
Date: Mon, 26 Jul 2010 15:56:58 +0530
X-Google-Sender-Auth: ozpeqFOmFXTrret9mQuA8R9kmf4
Message-ID: <AANLkTikxoRcPErYdc05HyMctmizS_e9gt=esMuZKhfuC@mail.gmail.com>
Subject: Re: [PATCH 3/4] vmscan: convert mm_vmscan_lru_isolate to DEFINE_EVENT
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

On Mon, Jul 26, 2010 at 8:35 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Mel Gorman recently added some vmscan tracepoints. Unfortunately
> they are covered only global reclaim. But we want to trace memcg
> reclaim too.
>
> Thus, this patch convert them to DEFINE_TRACE macro. it help to
> reuse tracepoint definition for other similar usage (i.e. memcg).
> This patch have no functionally change.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir
