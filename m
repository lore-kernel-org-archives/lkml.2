Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0HRLHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 07:07:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33681 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0HRLHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 07:07:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Iih1a7qXq5MXIRJ/qIobrAKrIk9iz3VD4DsofFXxoX75haHgN3uElpC+xXrhE1/mE0
         IvYvBYRQGY7cuLUpUHjkSOp4B1vs0RUGFI14+VLMUJw5cGLUSVYxf5YNgxndiIn+LpAO
         6Q/C8qJcpzyEM7PHmYs+AU+Dw3gIbDmyRHCA4=
MIME-Version: 1.0
Date: Wed, 18 Aug 2010 14:07:05 +0300
Message-ID: <AANLkTin5K=ii_ZhQ1hFm7wfcqfhdQhrUh-mXS7ZAy=h-@mail.gmail.com>
Subject: Staging drivers das08_cs.c compile error
From: Anca Emanuel <anca.emanuel@gmail.com>
To: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux 2.6.36-rc1 compile error:

drivers/staging/comedi/drivers/das08_cs.c: In function
‘das08_pcmcia_config_loop’:
drivers/staging/comedi/drivers/das08_cs.c:225: error: ‘struct
pcmcia_device’ has no member named ‘io’
