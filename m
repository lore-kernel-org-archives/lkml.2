Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0IBL5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 07:57:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39637 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0IBL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 07:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=StbPXAFtplN7M11LPVseDgHQ3qtxXePJJAGa2WqS97UHBDr6OcdtucJ2RpF5H5JLjr
         M9mdbx3YokXNF+3/HcXahNXnjo+3szis0ygetFQd8pdeO4j8rVlTeJ2Pv+5ciN1Cedy9
         WQAzZRGGFXVHjYOq5kzaya7cuGbIlhz9nJp0E=
MIME-Version: 1.0
Date: Thu, 2 Sep 2010 17:27:19 +0530
Message-ID: <AANLkTi=ZzbTb+uQchDDYfNibDv=LafQYuvRe2TVFpFGO@mail.gmail.com>
Subject: Resetting USB HC .. During kernel boot
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        listar@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

   I want to reset the USB HC  while the booting is happening. I have
the register details and functionality with me, but not sure which
part of the code to insert this segment.

please advice me ...

thanks,
Prabhu
