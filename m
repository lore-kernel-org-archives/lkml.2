Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab0JZQCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:02:49 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46465 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab0JZQCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:02:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SLCv0xHcZpSYSGwySliHAgU4+uQ+EAzSccTs7H7xFTlnmIcGoi4c8BftabpsG+P0F9
         p0aqDpWL3kvd6uJHwlqiGzaPoremW66Pj1Pnpc92Gp7c9wt/wseQ5UmcKC3f0ayQJf2M
         mlyzd4Z+7zcoJA67sYRm3wQMVSgcwEPxYa3Ng=
Subject: Re: [PATCH] sparc32: make CONFIG_SPARC_LEON depends on !SMP to fix
 build failure
From: Namhyung Kim <namhyung@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101026.085338.104057457.davem@davemloft.net>
References: <1288108303-2712-1-git-send-email-namhyung@gmail.com>
	 <20101026.085338.104057457.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 01:02:40 +0900
Message-ID: <1288108960.1717.1.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-26 (화), 08:53 -0700, David Miller:
> Great, I'll apply all three of your patches thanks.

Thanks. BTW, can you please take a look below too?

http://lkml.org/lkml/2010/10/25/13


-- 
Regards,
Namhyung Kim


