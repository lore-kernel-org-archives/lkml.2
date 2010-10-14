Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0JNEWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:22:39 -0400
Received: from senator.holtmann.net ([87.106.208.187]:34318 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0JNEWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:22:38 -0400
Subject: Re: [PATCH -next] bluetooth: fix hidp kconfig dependency warning
From: Marcel Holtmann <marcel@holtmann.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        linux-bluetooth@vger.kernel.org
In-Reply-To: <20101013181652.7ddf481e.randy.dunlap@oracle.com>
References: <20101013181652.7ddf481e.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 07:22:35 +0300
Message-ID: <1287030155.3316.20.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> Fix kconfig dependency warning to satisfy dependencies:
> 
> warning: (BT_HIDP && NET && BT && BT_L2CAP && INPUT || USB_HID && HID_SUPPORT && USB && INPUT) selects HID which has unmet direct dependencies (HID_SUPPORT && INPUT)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

looks fine to me.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


