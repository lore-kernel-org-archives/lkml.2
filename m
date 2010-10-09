Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab0JIQUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 12:20:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33079
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755957Ab0JIQUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 12:20:42 -0400
Date: Sat, 09 Oct 2010 09:21:03 -0700 (PDT)
Message-Id: <20101009.092103.91350825.davem@davemloft.net>
To: leitao@linux.vnet.ibm.com
Cc: nikai@nikai.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ehea: simplify conditional
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CAE5C71.50304@linux.vnet.ibm.com>
References: <20101008011450.0126ffc0@absol.kitzblitz>
	<4CAE5C71.50304@linux.vnet.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitao <leitao@linux.vnet.ibm.com>
Date: Thu, 07 Oct 2010 20:49:05 -0300

> On 10/07/2010 08:14 PM, Nicolas Kaiser wrote:
>> Simplify: ((a&&  b) || (!a&&  !b)) =>  (a == b)
>>
>> Signed-off-by: Nicolas Kaiser<nikai@nikai.net>
> Acked-by: Breno Leitao <leitao@linux.vnet.ibm.com>

Applied.
