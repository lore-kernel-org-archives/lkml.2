Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0EZSNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:13:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:34078 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab0EZSNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vMtlR4tw5gXQNErcQybsPyr3ZT6IiLw30P/HDPXhYK8poQ7D8401BxatYX8qFhyrW4
         xhlWrpOunfnFEoHBloUaHyaROzVaXyXWZI69lCBfvJemQ8PxzyRH88SRtjCR2cJwUcDA
         hQTWKPyhNM0wYV3oQDXdwmCoaf2w/wpMU5KJo=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1005261756150.23743@ask.diku.dk>
References: <Pine.LNX.4.64.1005261756150.23743@ask.diku.dk>
Date: Wed, 26 May 2010 20:13:32 +0200
Message-ID: <AANLkTilnCabvmeF11Rx7XlEHxwqrnBk2JLznOBLrCHuC@mail.gmail.com>
Subject: Re: [PATCH 8/17] net/caif: Add missing spin_unlock
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Add a spin_unlock missing on the error path.  The spin lock is used in a
> balanced way elsewhere in the file.

This bug is already fixed an part of net-2.6 in
"[PATCH net-2.6 5/6] caif: Bugfix - missing spin_unlock".

Regards
Sjur
