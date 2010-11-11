Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab0KKDNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:13:43 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:22544 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104Ab0KKDNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:13:41 -0500
Message-ID: <000a01cb814e$70565790$66f8800a@maildom.okisemi.com>
From: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
To: "Joe Perches" <joe@perches.com>
Cc: "Michal Nazarewicz" <m.nazarewicz@samsung.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "linux-usb" <linux-usb@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Andrew" <andrew.chih.howe.khor@intel.com>,
        "Intel OTC" <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
References: <4CDB514A.5090803@dsn.okisemi.com> <1289442175.15905.119.camel@Joe-Laptop>
Subject: Re: [PATCH v10] USB device driver of Topcliff PCH
Date: Thu, 11 Nov 2010 12:13:32 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe

Thank you for your comment.

-----
Date: Wed, 10 Nov 2010 18:22:55 -0800
From: "Joe Perches" <joe@perches.com>
> 
> It seems several of the dev_<level> logging messages
> need to be terminated with a "\n"
> 
> []
> 

It was mistake.
I add "\n" to logging messages and resubmit.

Best regards
Toshiharu Okada (OKI SEMICONDUCTOR)
