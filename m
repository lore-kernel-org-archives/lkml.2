Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2BTTOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:14:42 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45528 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678Ab2BTTOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:14:40 -0500
X-Sasl-enc: xt27iqhORwlV3ZPdqqPRE5O7j+0sPn2TFeLhcgiv/zee 1329765280
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: Colin Walters <walters@verbum.org>
To: Javier Martinez Canillas <javier@collabora.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alban Crequy <alban.crequy@collabora.co.uk>,
        Bart Cerneels <bart.cerneels@collabora.co.uk>,
        Rodrigo Moya <rodrigo.moya@collabora.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 20 Feb 2012 14:13:44 -0500
In-Reply-To: <1329753455-1106-1-git-send-email-javier@collabora.co.uk>
References: <1329753455-1106-1-git-send-email-javier@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1329765252.22425.3.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 16:57 +0100, Javier Martinez Canillas wrote:
> This patch-set add multicast support to Unix domain socket familiy for datagram
> and seqpacket sockets. This work was made by Alban Crequy as a result of a
> research we have been doing to improve the performance of the D-bus IPC system.

Do you have links to any modifications to userspace dbus to take
advantage of this?



