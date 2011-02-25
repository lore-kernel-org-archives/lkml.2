Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab1BYKwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:52:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34463 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab1BYKwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:52:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IRHpKDlGIMctOPijdLPIJCO5sNT/WXzSS61vwABR/94HaixXeAHlYJ3ZKzDSRorcoy
         xA6q05Gpw651CxiM/CQq3VQBdotbLkHOV5VSZ3Orvs46kWUkfPWsadyl7HUC7xKPLzt1
         +HTLbEP0Zhp+1ODkTi2dN3QQsrV/rRGRv2CCM=
Subject: Re: [PATCH] fs/jffs2/xattr: Fix coding style
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tracey Dent <tdent48227@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110221093902.GA4759@linux-rdzc.hsd1.mi.comcast.net>
References: <20110221093902.GA4759@linux-rdzc.hsd1.mi.comcast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 12:51:14 +0200
Message-ID: <1298631074.2798.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-21 at 04:39 -0500, Tracey Dent wrote:
> Remove the trailing white space and get rid of the
> unnessary {} on certain statements.
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>

Could you please do one change per patch?

Make first patch to only fix the trailing white-space issue. I'd take it
to my tree immediately. You can make the second patch which removes
unnecessary {}, but this patch would be arguable, I'm not sure I'd take
it.

In any case, now I should reject whole patch, but in the "one patch per
logical change" case I'd take at least part of your work.

Thanks a lot!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

