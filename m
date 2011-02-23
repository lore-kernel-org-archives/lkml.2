Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1BWANU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:13:20 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:30996 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505Ab1BWANS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:13:18 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Greg KH'" <greg@kroah.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@suse.de>,
        "'Alan Cox'" <alan@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <toshiharu-linux@dsn.okisemi.com>
References: <1297995844-11282-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20110222235133.GA31831@kroah.com>
Subject: RE: [PATCH 1/8] pch_uart: add multi-scatter processing
Date: Wed, 23 Feb 2011 09:13:15 +0900
Message-ID: <0180FEFC7EED4640A1AF46ECCFA60FF1@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcvS656WQ4LtF0o4TOWzsa6Wv2ZDwgAAmJnw
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <20110222235133.GA31831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, 

On Wednesday, February 23, 2011 8:52 AM, Greg KH wrote:
> What kernel tree did you make this against?  the pch_uart.c 
> file is not in this location anymore.
> 
> Care to redo this series against the linux-next tree so that 
> I can apply it properly?

this patch series is for linux-next.
I will repost the patches again.

[PATCH 1/8] -> [PATCH linux-next 1/8]

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

