Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab1DEEjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 00:39:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36584 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1DEEjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 00:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q2GEf9yjhtqwlfn2PK6ogeUFNufytJ7qmbLGeUIZjz98UlBQZCH/c2xP5Q/jPdFudQ
         tXqOI7JktheRPxNN8LcU8/DCJir2CKjnMFelxwMVbKCUxMpDhcWHDcnpb+GA/Q8XXp28
         C8jzrPY/s1un6viiHWpswY+dfuD8AIPkvsQ0Y=
Subject: Re: [PATCH] MTD: Retry Read/Write Transfer Buffer Allocations
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Grant Erickson <marathon96@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>
In-Reply-To: <C9BF3A4C.27686%marathon96@gmail.com>
References: <C9BF3A4C.27686%marathon96@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 07:39:41 +0300
Message-ID: <1301978381.2608.29.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 09:05 -0700, Grant Erickson wrote:
> I propose a two-stage approach. This issue has been in the kernel for about
> six years. 
> 
> Can we take a modified version of Jarkko's or my simpler fixes for the first
> pass and then iterate toward the get_user_pages scatter/gather approach

Sure, I've just commented on your patch.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

