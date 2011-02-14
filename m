Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1BNOgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:36:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:32820 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1BNOgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:36:21 -0500
Date: Mon, 14 Feb 2011 12:36:47 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] bluethooth: sco: fix information leak to userspace
Message-ID: <20110214143647.GB2597@joana>
References: <1297680867-11551-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297680867-11551-1-git-send-email-segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasiliy,

* Vasiliy Kulikov <segoon@openwall.com> [2011-02-14 13:54:26 +0300]:

> struct sco_conninfo has one padding byte in the end.  Local variable
> cinfo of type sco_conninfo is copied to userspace with this uninizialized
> one byte, leading to old stack contents leak.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Compile tested.
> 
>  net/bluetooth/sco.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied as well, thanks.

-- 
Gustavo F. Padovan
http://profusion.mobi
