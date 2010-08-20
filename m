Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab0HTVAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:00:11 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44830 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0HTVAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=tI0DHUTMO7L9Kzxy/efEI/Trtp2laOy6f/nBjSG9MYxelAsw2UE3ij60TjLoK3A29i
         /7jn0l1EbofwIAN/ap8CBmDy5nu5Y+UFQzqs8SewSzo0XMKPWqAKWIJlc3oYkJB8Gulx
         Q90FLDn1JX23/Vte74CmXn1wY+TMpjE80/4jY=
MIME-Version: 1.0
Date: Fri, 20 Aug 2010 17:00:08 -0400
Message-ID: <AANLkTi=AHHjL-Yk2dqarSpTo7wHBR+NKUkgaYwZDodDL@mail.gmail.com>
Subject: [PATCH 0/8] Staging: rtl8187se: fixed checkpatch.pl coding style issues
From: T Dent <tdent48227@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, bzolnier@gmail.com, Larry.Finger@lwfinger.net,
        joe@perches.com, pshah.mumbai@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have fixed numerous Linux kernel coding style issues using
checkpatch.pl with the help of the video that Greg Kroah-Hartman
lecture on about writing and sending your first patch.

I corrected 3260 warnings, 236 errors, and deleted 231 lines of
unnecessary code which still keeps the code readability.

--
Tracey Dent
