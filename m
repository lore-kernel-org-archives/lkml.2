Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2HWGkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:40:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33820 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2HWGkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:40:20 -0400
Date: Wed, 22 Aug 2012 23:40:19 -0700 (PDT)
Message-Id: <20120822.234019.1546353507351890178.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: cjren@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca-linux-team@qualcomm.com,
        nic-devel@qualcomm.com, rodrigue@qca.qualcomm.com
Subject: Re: [PATCH v2] net: add new QCA alx ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <157393863283F442885425D2C45428562A4F5169@nasanexd02f.na.qualcomm.com>
References: <1345480949-14800-1-git-send-email-cjren@qca.qualcomm.com>
	<20120822.225700.714020017287504609.davem@davemloft.net>
	<157393863283F442885425D2C45428562A4F5169@nasanexd02f.na.qualcomm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Huang, Xiong" <xiong@qca.qualcomm.com>
Date: Thu, 23 Aug 2012 06:35:40 +0000

>> This is why we require that portable, sane, interfaces are added to ethtool for
>> driver diagnostics.  That way users can perform a task in the same way
>> regardless of what hardware and driver are underneath.
> 
> I quite agree you on using ethtool to implement it. we did consider it. 
> But ethtool has some limitation, for example, the NIC has built-in OTP (TWSI interface)
> And Flash (External SPI interface),  their properties are quite different with EEPROM which
> Ethtool supports.
> To support such memory (OTP/Flash), we need additional input parameters.

Then add a new ethtool operation to support your use case, that's
exactly what I was telling you to do.

Did it really not occur to you that you perhaps you should extend
existing generic facilities to suit your needs instead of creating
private facilities that no other driver can use?

