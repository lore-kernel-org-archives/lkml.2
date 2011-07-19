Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1GSEQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 00:16:03 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:45472 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab1GSEQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 00:16:01 -0400
Message-ID: <4E2504FD.6090107@dsn.okisemi.com>
Date: Tue, 19 Jul 2011 13:15:57 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Alexander Stein <alexander.stein@systec-electronic.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>
Subject: serial/pch_uart: AT command behavior
References: <1308736219-19975-1-git-send-email-alexander.stein@systec-electronic.com> <4E02857C.1010304@dsn.okisemi.com>
In-Reply-To: <4E02857C.1010304@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question for UART driver AT command behavior.
When installing pch_uart, AT command "AT+GCAP^M" are sent for 4 times.
This command is sent first install only.
(After the above, removing pch_uart and installing pch_uart again,
this command is not sent.)

Let me know the behavior is normal or not ?

Thanks,
-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
