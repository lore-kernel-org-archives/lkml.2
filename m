Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab1DDJoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:44:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45855 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1DDJoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=xbRVnqJhATBnnLsMlwfmlpZcoY09vbVSPIsa5rL5am8QnVVAeVip4HBX9zSbMI/rj/
         3FkJZIrCXV/c8BlAv+RsIy3pW8SF2iRcb9Tu9J0Ho2ctgnJSpiBenOUBjINFN7SP4Ksd
         T+yDAL/VVMbWUDc98wyDmT56a9LN5ID5XkwM8=
Date: Mon, 4 Apr 2011 17:44:00 +0800
From: "wanlong.gao" <wanlong.gao@gmail.com>
To: "Dominik Brodowski" <linux@dominikbrodowski.net>
Cc: "davem" <davem@davemloft.net>, "padovan" <padovan@profusion.mobi>,
        "joe" <joe@perches.com>, "marcel" <marcel@holtmann.org>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1301909548-20031-1-git-send-email-wanlong.gao@gmail.com>,
 <20110404093620.GA4896@isilmar-3.linta.de>
Subject: Re: Re: [PATCH] X86:NET:Replaced a deprecated function .
Message-ID: <201104041743511096883@gmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You means that some drivers still not capable of IRQF_SHARED?

Thanks 

