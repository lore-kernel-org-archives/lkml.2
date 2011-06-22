Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1FVFeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 01:34:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62999 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1FVFef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 01:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=pegWEn5Dxp6BVZRB+PNZNzgG1UMqIwVeRzFUxrHL8znEtiqtt5giGdXw1a3wcvUKd+
         skYsk8NQUqLSAGyKmq3Y8aA18Puv+EHEak64+MRwQgGbJcVnibw2L/LCs0csEiCZQ/W0
         JhuXamIQ/Ea6jhP6W8ZcXXEmEFx1oiZRKCfw8=
Subject: Re: [PATCH/Trivial] jffs2: Avoid unneeded 'if' before kfree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, trivial@kernel.org
Date: Wed, 22 Jun 2011 08:35:17 +0300
In-Reply-To: <alpine.LNX.2.00.1106132213500.30934@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106132213500.30934@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308720921.18119.33.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 22:16 +0200, Jesper Juhl wrote:
> kfree() deals gracefully with NULL pointers, so it's pointless to test for 
> one prior to calling it.
> This removes such a test from jffs2_scan_medium().
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

