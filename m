Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab0GHV6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 17:58:13 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48577 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0GHV6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 17:58:12 -0400
Subject: Re: [PATCH 20/37] drivers/bluetooth: Use kmemdup
From: Marcel Holtmann <marcel@holtmann.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005152318590.21345@ask.diku.dk>
References: <Pine.LNX.4.64.1005152318590.21345@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 18:57:04 -0300
Message-ID: <1278626224.10421.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

> Use kmemdup when some other buffer is immediately copied into the
> allocated region.

patch has been applied to bluetooth-next-2.6 tree. Thanks.

Regards

Marcel


