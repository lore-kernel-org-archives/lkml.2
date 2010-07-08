Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab0GHWBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 18:01:46 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48589 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0GHWBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 18:01:45 -0400
Subject: Re: [PATCH 9/20] drivers/bluetooth: Use kzalloc
From: Marcel Holtmann <marcel@holtmann.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005132201470.6282@ask.diku.dk>
References: <Pine.LNX.4.64.1005132201470.6282@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 19:01:19 -0300
Message-ID: <1278626479.10421.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

> Use kzalloc rather than the combination of kmalloc and memset.
> 

patch has been applied to bluetooth-next-2.6 tree. Thanks.

Regards

Marcel


