Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab1EXOny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:43:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57821 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab1EXOnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K/dUgSWEYHrj+E9snITlFp0cwAZh2nfNqJ58nxvafumL5luP0PmLQJH/lFYq+yh5MK
         gBJ7pev8UplrmH+D0IC5AZboh6gVXyHPuvul8muBooh4AZsd19Ts+rBSrzqNB2RMJRcN
         +qJ00jHiTq8a4D+9nKswDsvkgPjysD7UUtCa4=
Date: Tue, 24 May 2011 17:42:00 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: rmallon@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, hsweeten@visionengravers.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ep93xx DMA patches
Message-ID: <20110524144200.GA2815@acer>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <4DDABF2C.2010708@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDABF2C.2010708@bluewatersys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 08:10:20AM +1200, Ryan Mallon wrote:
> 
> It sounds like the SPI code is pretty well tested already?

Yes, the SPI code should be pretty well tested.

> Also, can you please update my email in the patches to
> "rmallon@gmail.com" (add my Signed-off-by if you want).

Will do.

Thanks,
MW
