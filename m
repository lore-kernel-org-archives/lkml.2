Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979Ab0L2Glc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 01:41:32 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54491 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0L2Glb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 01:41:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hHHccyuGIRXWcmbE9wJKPjYcj1rbNmrGCqo/0J0qdFh1vToOCGyJsBF0woNVZIG8hf
         WRtLVXwijQHf7+KfZ+P43YxmLxRez8hKuZG2R3VYkKqcsj4sqDhpGh5T7zGLrmR0bD2Y
         j/PI5O1c6j2Nre6E3PXC3GF8J5fZnaL2oIrjM=
MIME-Version: 1.0
In-Reply-To: <20101229130700.0ef93735.sfr@canb.auug.org.au>
References: <20101229130700.0ef93735.sfr@canb.auug.org.au>
Date: Wed, 29 Dec 2010 08:41:29 +0200
Message-ID: <AANLkTikq50KLGwS1_=uA=TXz2b=LNzr_TKUSiZu-an1m@mail.gmail.com>
Subject: Re: linux-next: Tree for December 29
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/staging/cx25821/cx25821-video.o
drivers/staging/cx25821/cx25821-video.c: In function ‘video_open’:
drivers/staging/cx25821/cx25821-video.c:817: error: implicit
declaration of function ‘lock_kernel’
drivers/staging/cx25821/cx25821-video.c:834: error: implicit
declaration of function ‘unlock_kernel’
make[4]: *** [drivers/staging/cx25821/cx25821-video.o] Error 1
make[3]: *** [drivers/staging/cx25821] Error 2
make[2]: *** [drivers/staging] Error 2
