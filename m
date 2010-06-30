Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0F3UKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:10:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36728
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab0F3UKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:10:11 -0400
Date: Wed, 30 Jun 2010 13:10:24 -0700 (PDT)
Message-Id: <20100630.131024.190380261.davem@davemloft.net>
To: gustavo@padovan.org
Cc: dhowells@redhat.com, linux-bluetooth@vger.kernel.org,
       justinmattock@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix abuse of the preincrement operator
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100628131058.GA25275@vigoh>
References: <1277621246-10960-6-git-send-email-justinmattock@gmail.com>
	<20100628125752.8945.50572.stgit@warthog.procyon.org.uk>
	<20100628131058.GA25275@vigoh>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Gustavo F. Padovan" <gustavo@padovan.org>
Date: Mon, 28 Jun 2010 10:12:30 -0300

> Hi David,
> 
> * David Howells <dhowells@redhat.com> [2010-06-28 13:57:52 +0100]:
> 
>> Fix abuse of the preincrement operator as detected when building with gcc
>> 4.6.0:
>> 
>> 	 CC [M]  drivers/bluetooth/hci_bcsp.o
>> 	drivers/bluetooth/hci_bcsp.c: In function 'bcsp_prepare_pkt':
>> 	drivers/bluetooth/hci_bcsp.c:247:20: warning: operation on 'bcsp->msgq_txseq' may be undefined
>> 
>> Reported-by: Justin P. Mattock <justinmattock@gmail.com>
>> Signed-off-by: David Howells <dhowells@redhat.com>
...
> Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

Applied, thanks everyone.
