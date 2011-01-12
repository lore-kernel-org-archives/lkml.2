Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab1ALB7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 20:59:41 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:32296 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319Ab1ALB7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 20:59:39 -0500
From: "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
To: "'Greg KH'" <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>,
        "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
References: <1292992394-3264-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20101222044424.GC19006@suse.de>
Subject: RE: [PATCH] pch_phub: add new device ML7213
Date: Wed, 12 Jan 2011 10:59:35 +0900
Message-ID: <9E719661EAC44CEBAE5E5E0ABD51B4E0@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <20101222044424.GC19006@suse.de>
Thread-Index: Acuhks76AE2RKSzETTmGEkXpK1MkVwQZussw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wednesday, December 22, 2010 1:44 PM, Greg KH wrote:
> Put the device type here in the device table, so you don't 
> have to check for it again in the probe function.  That way 
> you can save some code and keep things simpler and more 
> obvious in the future when adding new device ids, that you 
> also have to pick the type for it.

Have you reviewed our "v2 patch" which is modified for the above?

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

