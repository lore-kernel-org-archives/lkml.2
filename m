Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2HXO4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:56:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47237 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2HXOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:55:47 -0400
Message-ID: <1345820142.4824.1.camel@edumazet-laptop>
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        John W Linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 24 Aug 2012 16:55:42 +0200
In-Reply-To: <50378B35.80307@lwfinger.net>
References: <50345B12.1050600@lwfinger.net>
	  <1345612503.5158.566.camel@edumazet-glaptop>
	  <50355021.7000408@lwfinger.net>
	 <1345694593.5904.87.camel@edumazet-glaptop>
	  <50369925.3050705@lwfinger.net>
	 <1345757200.5904.1890.camel@edumazet-glaptop> <50378B35.80307@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 24 août 2012 à 09:09 -0500, Larry Finger a écrit :

> With kernel 3.6-rc2, the error changes to the following:
> 
> ============================================================================
> --2012-08-24 08:26:42--  https://bugzilla.redhat.com/show_bug.cgi?id=847525
> Resolving bugzilla.redhat.com (bugzilla.redhat.com)... 209.132.183.69
> Connecting to bugzilla.redhat.com (bugzilla.redhat.com)|209.132.183.69|:443... 
> connected.
> HTTP request sent, awaiting response... 200 OK
> Length: unspecified [text/html]
> Saving to: `show_bug.cgi?id=847525.3'
> 
>      [ <=>                          ] 0           --.-K/s   in 0s
> 
> 2012-08-24 08:26:45 (0.00 B/s) - Read error at byte 0 (error:1408F119:SSL 
> routines:SSL3_GET_RECORD:decryption failed or bad record mac).Retrying.
> ============================================================================
> 

> Anything else to try?

When this happens, nothing in kernel log ?

Could you do

strace -o STRACE -s 8000 wget https://bugzilla.redhat.com/show_bug.cgi?id=847525

and send the STRACE file when you get a failure ?

Thanks



