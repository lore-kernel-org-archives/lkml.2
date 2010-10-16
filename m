Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab0JPX0J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 19:26:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59390 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab0JPX0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 19:26:07 -0400
Date: Sat, 16 Oct 2010 20:25:12 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Nathan Holstein <nathan.holstein@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] fix oops in l2cap_connect_req
Message-ID: <20101016232512.GB12187@vigoh>
References: <AANLkTi=CNW1pu-YdvmViqHxfw-_TDzvLkj15Ai_aANWo@mail.gmail.com>
 <20101014213709.GD9250@vigoh>
 <AANLkTi=xxj81e__fH1Bh8KuL_rmHVi0=ia9ELPUMThr-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=xxj81e__fH1Bh8KuL_rmHVi0=ia9ELPUMThr-@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nathan,

* Nathan Holstein <nathan.holstein@gmail.com> [2010-10-15 11:54:02 -0400]:

> In error cases when the ACL is insecure or we fail to allocate a new
> struct sock, we jump to the "response" label.  If so, "sk" will be
> null and the kernel crashes.
> 
> Signed-off-by: Nathan Holstein <nathan.holstein@gmail.com>
> ---
>  net/bluetooth/l2cap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
