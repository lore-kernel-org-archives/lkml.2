Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1CGIyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:54:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46426 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab1CGIyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:54:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PGr90EnCRK7soMboaqy607V9rAh9iqlRljfQEHHZ+JARt+gFwTNXvShhx0CsKzQRPB
         EHz55fo4cZAxy5pIQIDXK0zlOqF0cTHza3LDmDi6wyrhcuZ0EglzPG7/hp1/eWv4mzoJ
         QB6iO9+7kh3JxVeaxyGX2MsVWKT0+zD1ycvPw=
Subject: Re: [PATCH 1/2] mtd: nand: Allow NAND chip ids to be included
 standalone.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Murali Nalajala <mnalajal@codeaurora.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>
In-Reply-To: <1298940450-27365-1-git-send-email-mnalajal@codeaurora.org>
References: <1298940450-27365-1-git-send-email-mnalajal@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 10:53:12 +0200
Message-ID: <1299487992.2746.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 06:17 +0530, Murali Nalajala wrote:
> Lets non-standard NAND drivers take advantage of known NAND
> chip information.
> 
> Signed-off-by: Dima Zavin <dima@android.com>
> Signed-off-by: Murali Nalajala <mnalajal@codeaurora.org>

Please, make the description more descriptive. Please, make it explain
which problem you are solving and how. What do you mean by non-standard
drivers? Why they are non-standard?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

