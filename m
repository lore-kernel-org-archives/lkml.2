Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2HTGdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:33:25 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:59721 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004Ab2HTGdX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:33:23 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel MARTENSSON <daniel.martensson@stericsson.com>
Date: Mon, 20 Aug 2012 08:33:35 +0200
Subject: RE: [PATCH] caif: Do not dereference NULL in chnl_recv_cb()
Thread-Topic: [PATCH] caif: Do not dereference NULL in chnl_recv_cb()
Thread-Index: Ac18t4fptvoWAhZFQSeFassFvsfasAB5fc8A
Message-ID: <81C3A93C17462B4BBD7E272753C1057923B924D522@EXDCVYMBSTM005.EQ1STM.local>
References: <alpine.LNX.2.00.1208172230570.15699@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1208172230570.15699@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In net/caif/chnl_net.c::chnl_recv_cb() we call skb_header_pointer()
> which may return NULL, but we do not check for a NULL pointer before
> dereferencing it.
> This patch adds such a NULL check and properly free's allocated memory
> and return an error (-EINVAL) on failure - much better than crashing..
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thank you for fixing this, the patch looks good to me.
Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
