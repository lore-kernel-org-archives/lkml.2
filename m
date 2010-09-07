Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0IGJeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:34:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49483 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab0IGJeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=O9lDHDeb/DC/JI5KuuXcIQvz0vRrHQkS8HhvbOYFCpK8SaiU0JdonPqVpIJJWi1Ez/
         ajGL+E16dHcnU8VU8IgUZ56i6zELNAL9BZtmhhWe9xl5fxP9GgQwPrhcr3la2DzGJ6e5
         dWho6p9yOR32RsmtEcPomE0y2NQ4aoDdeMFYI=
Subject: Re: [PATCH 11/14] ubifs: check return code of ubifs_lpt_lookup
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>,
        Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1283711580-7546-1-git-send-email-segooon@gmail.com>
References: <1283711580-7546-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Sep 2010 12:32:39 +0300
Message-ID: <1283851959.2979.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-05 at 22:33 +0400, Kulikov Vasiliy wrote:
> From: Vasiliy Kulikov <segooon@gmail.com>
> 
> Function ubifs_lpt_lookup may return ERR_PTR(...). Check for it.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---

Pushed both patches to the UBIFS tree, thanks:

http://git.infradead.org/ubifs-2.6.git

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

