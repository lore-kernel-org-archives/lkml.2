Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0EOWyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 18:54:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57353 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0EOWyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 18:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=adtUncYBWfoC+AGnD3EAXDFDHIyJda/B6qPiD3sJ5CxnHTlEMTVjn3i3TL8xMuR9P2
         nsEonDBo6Zaw1paSRc6tG5uZ0tvAcMyleSt0ZvwV4moDO7ovYRxTPsG0ZlmXLaSwMBXp
         RQfMBlqjN/op7beVBrj2s4sQF7XnhJ93z4Q0Q=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1005132203150.6282@ask.diku.dk>
References: <Pine.LNX.4.64.1005132203150.6282@ask.diku.dk>
Date: Sun, 16 May 2010 00:54:17 +0200
Message-ID: <AANLkTim4uGaZ_RDawZSrjWybdZc60_oSl1s45qrmVn--@mail.gmail.com>
Subject: Re: [PATCH 13/20] net/caif: Use kzalloc
From: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> wrote:
>Use kzalloc rather than the combination of kmalloc and memset.

Thank you, this look good to me.
Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
