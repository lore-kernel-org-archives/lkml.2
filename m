Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0LARDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:03:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47424 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0LARDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:03:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GQNZZpwrittj1V46XIBegPVWjjWpFtCVn++cTTmGFsYva45a4OQY3vPdJjsfIHLVH2
         pEsx5ky2zyAUlgTB0pDwKBRmmv5LfHovZsymivhuocm332rxHpc8+txuMifNzUGgyDgm
         I2tPuIFqQt/yQk+OrtO79hL16eVMmncAgN/5s=
Subject: Re: [PATCH] MIPS: Fix build failure on mips_sc_is_activated()
From: Namhyung Kim <namhyung@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101201165517.GA5560@linux-mips.org>
References: <1291221282-9056-1-git-send-email-namhyung@gmail.com>
	 <20101201165517.GA5560@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 02:03:11 +0900
Message-ID: <1291222991.1684.49.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-01 (수), 16:55 +0000, Ralf Baechle:
> On Thu, Dec 02, 2010 at 01:34:42AM +0900, Namhyung Kim wrote:
> 
> > The commit ea31a6b20371 ("MIPS: Honor L2 bypass bit") breaks
> > malta build as follows. Looks like not compile-tested :(
> 
> Already fixed in the linux-mips git tree by an identical patch in
> commit 9a3475880131752d3d78ac25516fd3eab3fca871.
> 
> Thanks anyway!
> 
>   Ralf

Oh, didn't know that.
Thanks.

-- 
Regards,
Namhyung Kim


