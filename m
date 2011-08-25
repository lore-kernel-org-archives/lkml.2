Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab1HYErU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 00:47:20 -0400
Received: from mx02.ctc-g.co.jp ([131.248.58.2]:50667 "EHLO
	mx-s.ctc.ctc-g.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1HYErS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 00:47:18 -0400
Date: Thu, 25 Aug 2011 13:46:58 +0900
From: "Jun.Kondo" <jun.kondo@ctc-g.co.jp>
Subject: Re: [omega-g1:11110] Re: [PATCH] net: configurable sysctl parameter
 "net.core.tcp_lowat" for sk_stream_min_wspace()
In-reply-to: <20110822.113544.28950168095176936.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, omega-g1@ctc-g.co.jp, notsuki@redhat.com,
        motokazu.kozaki@hp.com, htaira@redhat.com, netdev@vger.kernel.org,
        tomohiko.takahashi@ctc-g.co.jp, kotaro.sakai@ctc-g.co.jp,
        ken.sugawara@ctc-g.co.jp
Reply-to: jun.kondo@ctc-g.co.jp
Message-id: <4E55D3C2.40308@ctc-g.co.jp>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-post-Received: by post02.ctc-g.co.jp (CTC-GN 2006/10/01) id 741DE74EE;	Thu,
 25 Aug 2011 13:46:56 +0900 (JST)
X-vs: by localhost.is02.ctc-g.co.jp (CTC-GN mail 2009/02/01) id 5D96153E5F;
	Thu, 25 Aug 2011 13:46:56 +0900 (JST)
X-vs: by is02.ctc-g.co.jp (CTC-GN mail 2009/02/01) id 55A0B53E5E;	Thu,
 25 Aug 2011 13:46:56 +0900 (JST)
References: <4E4E2CCD.6050809@ctc-g.co.jp>
 <20110819.024326.598275465899000817.davem@davemloft.net>
 <4E51A3F0.5010500@ctc-g.co.jp>
 <20110822.113544.28950168095176936.davem@davemloft.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; ja; rv:1.9.2.12)
 Gecko/20101027 Thunderbird/3.1.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, once the transmission buffer becomes full, it is not
possible to write again unless there is one third of free space
in the transmission buffer.

Our modification request is not intending to change the behavior
of the OS itself, but making the value "one third" to be
configurable, not fixed.

Thus it would be still possible to set the value to 1/3.

So, could you please tell us why it is not acceptable to make
it configurable, and what is the persistence with the value of
1/3?


