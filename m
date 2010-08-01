Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab0HAO2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 10:28:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36063 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab0HAO2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 10:28:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=SfpPSgXvVYxcMPCPkBdelbmU15436dlDpjkU68w131UR7WUQbtl244SRkYmjJm5sdY
         bWI58XDZYYPlXCVdqoxi7xXoZMaceUA8Bt8zkJp98G9KUbG0tbgvVnYIXygkmXbulqts
         7q6qBkYPXlzDvlwyaoe0tqhzEVo5XObByr/Fw=
MIME-Version: 1.0
Date: Sun, 1 Aug 2010 16:28:23 +0200
Message-ID: <AANLkTi=_oOViKt2=1ZHDQgRRLiYDBwOp=UY=XdGrtZsH@mail.gmail.com>
Subject: tracing lost time in early boot
From: Martin Pirker <lkml.collector@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

My machine "loses" quite some time at boot:
...
[    0.006881] ACPI: Core revision 20100428
[   45.284319] DMAR: Host address width 36
...

I digged through Documentation and tried some boot options but so far failed,
so could someone please point me to the right way to debug where exactly the
kernel is spending this time during boot?

thanks,
Martin
