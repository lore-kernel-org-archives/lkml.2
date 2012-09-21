Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2IUE64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 00:58:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36384 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2IUE6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 00:58:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6841"; a="237180625"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Jan Engelhardt'" <jengelh@inai.de>
Cc: <axboe@kernel.dk>, "'Jeff Moyer'" <jmoyer@redhat.com>,
        <linux-arm-msm@vger.kernel.org>,
        "'open list:DOCUMENTATION'" <linux-doc@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1344166241-18708-1-git-send-email-tlinder@codeaurora.org> <1344166241-18708-3-git-send-email-tlinder@codeaurora.org> <x49wr1cdlmg.fsf@segfault.boston.devel.redhat.com> <alpine.LNX.2.01.1209190718030.29967@nerf07.vanv.qr> <alpine.LNX.2.01.1209210631060.13993@nerf07.vanv.qr>
In-Reply-To: <alpine.LNX.2.01.1209210631060.13993@nerf07.vanv.qr>
Subject: RE: [RFC/PATCH 2/2] block: Adding ROW scheduling algorithm
Date: Fri, 21 Sep 2012 07:58:19 +0300
Message-ID: <003d01cd97b5$ba4e70b0$2eeb5210$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDJuLehQ41MV6PNI9g9xYZZQALMCAF/d/PIAjSnSN0A9BjMRQGgFO0lmWm3IyA=
Content-language: he
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan

> There seems to a bug with ROW. After about 43 hours of continued
> operation, programs (./configure was what I ran at the time this
> happened) first become slow, then got stuck in D state within a minute.
Ctrl-
> C/Z worked at first, soon not, then these messages appeared in dmesg.
> 
> [319952.630605] row: forced dispatching is broken (nr_sorted=17), please
> report this [319952.631174] row: forced dispatching is broken
(nr_sorted=17),
> please report this

Thank you very much for reporting this! 
We're now at the testing phase as well. We didn't encounter the bug you
observed but I'll look into it. Thanks again.

Thanks,
Tanya Brokhman
---
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

