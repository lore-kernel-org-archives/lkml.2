Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0LGAqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:46:49 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6073 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab0LGAqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 19:46:47 -0500
Message-ID: <EA73672426864370BC8119DE78037132@hacdom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <joel.clark@intel.com>, <kok.howg.ewe@intel.com>,
        <margie.foster@intel.com>
References: <4CECC07E.40804@dsn.okisemi.com> <4CECEE1E.9030201@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 8/17 v2] can: EG20T PCH: Change Copyright and module description
Date: Tue, 7 Dec 2010 09:46:42 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 24, 2010 7:51 PM, Marc Kleine-Budde wrote:
> Did your mailer spawn some extra spaces here? The header of your mail
> tells me:
> "User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.15)
> Gecko/20101027 Thunderbird/3.0.10"
> I strongly suggest to use git send-email.

At last, I can use "git send-email".
However, I have faced issue.
In case single destination address is OK, but in case multiple address is 
set,
I can see the following error.

Relay access denied

I show my failure command.
git send-email --smtp-server xxx.com --smtp-server-port yyy --smtp-ssl -to 
aaa.com -to bbb.com -to ccc.com
 -cc ccc.com -cc ddd.com -cc eee.com -bcc fff.com -bcc ggg.com *.patch

Do you have any information about the issue ?

Thanks

/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_
Tomoya Morinaga
OKI SEMICONDUCTOR CO., LTD. 

