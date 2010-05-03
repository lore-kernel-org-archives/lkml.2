Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0ECGca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 02:32:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50416
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720Ab0ECGc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 02:32:28 -0400
Date: Sun, 02 May 2010 23:32:32 -0700 (PDT)
Message-Id: <20100502.233232.66719719.davem@davemloft.net>
To: arnd@arndb.de
Cc: mst@redhat.com, sri@us.ibm.com, eric.dumazet@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       dlstevens@us.ibm.com
Subject: Re: [PATCH] macvtap: add ioctl to modify vnet header size
From: David Miller <davem@davemloft.net>
In-Reply-To: <201004291640.57280.arnd@arndb.de>
References: <20100429135158.GA26303@redhat.com>
	<201004291640.57280.arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 29 Apr 2010 16:40:57 +0200

> On Thursday 29 April 2010, Michael S. Tsirkin wrote:
>> This adds TUNSETVNETHDRSZ/TUNGETVNETHDRSZ support
>> to macvtap.
> 
> Looks good, thanks Michael!
> 
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Applied to net-next-2.6, thanks.
