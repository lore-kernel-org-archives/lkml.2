Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab0D3UOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:14:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab0D3UOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:14:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] macvtap: add ioctl to modify vnet header size
Date: Thu, 29 Apr 2010 16:40:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>,
       Sridhar Samudrala <sri@us.ibm.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Stevens <dlstevens@us.ibm.com>
References: <20100429135158.GA26303@redhat.com>
In-Reply-To: <20100429135158.GA26303@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004291640.57280.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+1yVrY4tubgV1fMk0PgNS5TMkRg5KDLwrviuC
 0BiZfW1YczWo2ifmgHpWlOET58pRbmRXf+NlNt8i93VpCYb2em
 LNb8e0P0duixmgGfg9IAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 April 2010, Michael S. Tsirkin wrote:
> This adds TUNSETVNETHDRSZ/TUNGETVNETHDRSZ support
> to macvtap.

Looks good, thanks Michael!

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
