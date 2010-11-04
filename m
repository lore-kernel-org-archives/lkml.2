Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab0KDB5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 21:57:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37023
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855Ab0KDB5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 21:57:36 -0400
Date: Wed, 03 Nov 2010 18:58:00 -0700 (PDT)
Message-Id: <20101103.185800.179950844.davem@davemloft.net>
To: amit.salecha@qlogic.com
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org,
        dhananjay.phadke@qlogic.com, narender.kumar@qlogic.com,
        netdev@vger.kernel.org
Subject: Re: [Patch] netxen: remove unused firmware exports
From: David Miller <davem@davemloft.net>
In-Reply-To: <99737F4847ED0A48AECC9F4A1974A4B80FCEAB435D@MNEXMB2.qlogic.org>
References: <20101103043021.5321.73681.sendpatchset@localhost.localdomain>
	<99737F4847ED0A48AECC9F4A1974A4B80FCEAB435D@MNEXMB2.qlogic.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Salecha <amit.salecha@qlogic.com>
Date: Wed, 3 Nov 2010 04:35:01 -0500

>> From: Amerigo Wang [amwang@redhat.com]
>> Sent: Wednesday, November 03, 2010 9:55 AM
>> To: linux-kernel@vger.kernel.org
>> Cc: Dhananjay Phadke; Amit Salecha; Narender Kumar; netdev@vger.kernel.org; David S. Miller; Amerigo Wang
>> Subject: [Patch] netxen: remove unused firmware exports
>>
>> Quote from Amit Salecha:
>> 
>> "Actually I was not updated, NX_UNIFIED_ROMIMAGE_NAME (phanfw.bin) is already
>> submitted and its present in linux-firmware.git.
>>
>> I will get back to you on NX_P2_MN_ROMIMAGE_NAME, NX_P3_CT_ROMIMAGE_NAME and
>> NX_P3_MN_ROMIMAGE_NAME. Whether this will be submitted ?"
>>
>> We have to remove these, otherwise we will get wrong info from modinfo.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Amit Kumar Salecha <amit.salecha@qlogic.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Dhananjay Phadke <dhananjay.phadke@qlogic.com>
>> Cc: Narender Kumar narender.kumar@qlogic.com
> 
> Acked-by:  Amit Kumar Salecha <amit.salecha@qlogic.com>

Applied.
