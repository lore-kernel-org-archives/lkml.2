Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1HSJ3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 05:29:13 -0400
Received: from mx.ctc-g.co.jp ([131.248.58.1]:34973 "EHLO mx.ctc.ctc-g.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab1HSJ3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 05:29:10 -0400
Date: Fri, 19 Aug 2011 18:28:45 +0900
From: "Jun.Kondo" <jun.kondo@ctc-g.co.jp>
Subject: Re: [omega-g1:10937] Re: [PATCH] net: configurable sysctl parameter
 "net.core.tcp_lowat" for sk_stream_min_wspace()
In-reply-to: <20110814.224714.2061635645365376268.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, omega-g1@ctc-g.co.jp, notsuki@redhat.com,
        motokazu.kozaki@hp.com, htaira@redhat.com, netdev@vger.kernel.org,
        tomohiko.takahashi@ctc-g.co.jp, kotaro.sakai@ctc-g.co.jp,
        ken.sugawara@ctc-g.co.jp
Reply-to: jun.kondo@ctc-g.co.jp
Message-id: <4E4E2CCD.6050809@ctc-g.co.jp>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-post-Received: by post02.ctc-g.co.jp (CTC-GN 2006/10/01) id B8A2076F6;	Fri,
 19 Aug 2011 18:28:53 +0900 (JST)
X-vs: by localhost.is01.ctc-g.co.jp (CTC-GN mail 2009/02/01) id A05885BEF3;
	Fri, 19 Aug 2011 18:28:53 +0900 (JST)
X-vs: by is01.ctc-g.co.jp (CTC-GN mail 2009/02/01) id 94CED5BEEE;	Fri,
 19 Aug 2011 18:28:53 +0900 (JST)
References: <4E48B0C3.2010203@ctc-g.co.jp>
 <20110814.224714.2061635645365376268.davem@davemloft.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; ja; rv:1.9.2.12)
 Gecko/20101027 Thunderbird/3.1.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You suggested to use non-blocking writes, but we think
we have to rewrite the Apache code if doing so.
That is, we have to make a modification to Apache that
depends on the architecture.
By using this patch, it can be handled by changing the
configuration a little bit on the kernel side for such
applications that it is difficult to do so on application
side.



(2011/08/15 14:47), David Miller wrote:
> From: "Jun.Kondo"<jun.kondo@ctc-g.co.jp>
> Date: Mon, 15 Aug 2011 14:38:11 +0900
>
>> 2. to limit the block time of the write in order to
>> prevent the timeout of upper layer applications
>> even when the connection has low throughput, such
>> as low rate streaming
> Use non-blocking writes if you want this behavior.
>


