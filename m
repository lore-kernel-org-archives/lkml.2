Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab1FVL02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:26:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37266 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab1FVL01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DTVybNo0wjtY9NyCYY1aPnsBVAKftMH9pyWv6kln21FfBzi+XhMMLf8D7+3tiHte0i
         Gcn1t291q4+YOcHeUAYI5tMXRvSjE1g8CBZaCVb0sD5cPqSLDzwVegbiYIavXrvZWtAC
         aZrVUqlSNg38LZdezupu5VmrfcWhToBUognX4=
MIME-Version: 1.0
Date: Wed, 22 Jun 2011 20:26:26 +0900
Message-ID: <BANLkTinSFErFBaZgeL4x1oiaw7woewUNVQ@mail.gmail.com>
Subject: threading problem
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,

I have a device driver which provides the IOCTL function for the
application to interact.

when the application sends the IOCTL CMD_GO, my driver has to toggle a
GPIO every 500 m Sec. until a 3 minute timeout occurs or a CMD_STOP
IOCTL is received.

I tried the DECLARE_WORK, DECLARE_DELAYED_WORK and also
kernel_thread() to meet this requirement with no success.

Any help is highly appreciated.

Thanks & regards
Murali
