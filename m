Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab1ADKOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:14:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33504 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1ADKOl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:14:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r6X2DtS81uMrCPm+Qrssu1eRi/o2GDNogso6ohpHVVEqdCR5SP1WIx5/omwavbSPXV
         22EBqXfs/H4512e55vk+TQaud3hiICQeStW/PSeDgQ8LdHlWkASsULS1xhZlMcy5tvDX
         DuNUDhoBUnXOciL/m7RtV0W/dQWf1ZWwhulwM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinkEQEhsHGGgJVp_pJohmrOAaa3dCJjNSDKS4Yj@mail.gmail.com>
References: <20110104164723.8bafcf7f.sfr@canb.auug.org.au>
	<AANLkTinkEQEhsHGGgJVp_pJohmrOAaa3dCJjNSDKS4Yj@mail.gmail.com>
Date: Tue, 4 Jan 2011 12:14:34 +0200
Message-ID: <AANLkTimHm5tgrvosqWPHAb4a_gCBGq5MiAR2tyUNCJPD@mail.gmail.com>
Subject: Re: linux-next: Tree for January 4
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/usb/serial/opticon.o
drivers/staging/cx25821/cx25821-video.c: In function ‘video_open’:
drivers/staging/cx25821/cx25821-video.c:817: error: implicit
declaration of function ‘lock_kernel’
drivers/staging/cx25821/cx25821-video.c:834: error: implicit
declaration of function ‘unlock_kernel’
make[4]: *** [drivers/staging/cx25821/cx25821-video.o] Error 1
make[3]: *** [drivers/staging/cx25821] Error 2
make[2]: *** [drivers/staging] Error 2
