Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab0IWBr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 21:47:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44560 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab0IWBr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 21:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sFfUun+MSBCw33YC55vTuaFS5lnjDNE+MUtfk4ghZIFxbwnjYR2iNQDEAsjOr/8fBq
         U5cenANUM64MDnhNGYgc7sFxvBhozsoyrT5CU6yxLRwtaN1gsUA0kG7qSP0s/WLFpUvq
         01cgMJhAU/wyZegYcNz64swzvpnKBkDbokdiE=
MIME-Version: 1.0
In-Reply-To: <AANLkTimXtigjQwpL6i46JTiuREdLnr7Yh+2ZCuPfy06G@mail.gmail.com>
References: <20100923112004.b47923b7.sfr@canb.auug.org.au>
	<AANLkTimXtigjQwpL6i46JTiuREdLnr7Yh+2ZCuPfy06G@mail.gmail.com>
Date: Wed, 22 Sep 2010 20:47:55 -0500
Message-ID: <AANLkTi=4tdTbsdkofgvUy5OTrzktE2sP2KHLtVwhOpEa@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 8:32 PM, Steve French <smfrench@gmail.com> wrote:
> Sorry about that - we merged one of Jeff's patches (in a series) out
> of order by three hours due to review comments.  Should be ok now -
> verifying.

Built fine.   Will try to merge the rest in order.


-- 
Thanks,

Steve
