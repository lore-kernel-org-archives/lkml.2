Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1CQKYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:24:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60777 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1CQKYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FhTrJJ6LMapa1h6PjPjZvHfOrOGtoTa84OPLhuBBRGHRsrXyiTRxiuDGOCz09Joy8a
         Kj9fB1NxtOEkS6EVXCEtlGpXy4WMTk/9IzKMygRYR/6rfT+zdEE6BQjisghb8KgaNWtG
         AOu9m1QW8UojxaRcCTcT65fepBK2bJ9b/tzms=
Subject: Re: [PATCH v2] net: add Faraday FTGMAC100 Gigabit Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com
In-Reply-To: <1300355238-1619-1-git-send-email-ratbert.chuang@gmail.com>
References: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com>
	 <1300355238-1619-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 11:24:17 +0100
Message-ID: <1300357457.3133.92.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 mars 2011 à 17:47 +0800, Po-Yu Chuang a écrit :
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> 
> FTGMAC100 Ethernet Media Access Controller supports 10/100/1000 Mbps
> and MII/GMII.  This driver has been working on some ARM/NDS32 SoC's
> including Faraday A369 and Andes AG102.
> 
> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
> ---

Did you tried GRO support ?


