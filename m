Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab1EMTmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 15:42:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34943 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1EMTmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 15:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BVI+mg8SKScSPJzE68lQP/s5VehLbK1w6O0ly8eUOp+1XlcQbPjShhrxGgintgpisV
         sMK9IcO43EUiQz6rF4j+gVqS0E8452JjbzhpYOUnjl7ykPo3ul4xkmNM+nL9jK65xAwq
         cqA9eGtsU3PtbIGLBp6ArY0myeqTI+KmFUMcM=
MIME-Version: 1.0
Date: Fri, 13 May 2011 16:42:36 -0300
Message-ID: <BANLkTik03b2CWwfVpN3atNfVZbDe=Wz3qw@mail.gmail.com>
Subject: PROBLEM: unable to enumerate USB device on port 6 (3 kernel test)
From: =?ISO-8859-1?Q?Franco_Gast=F3n_Pellegrini?= 
	<francogpellegrini@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested the kernels:

2.6.38-8-generic
2.6.39-0-generic (kernel-ppa/ppa)

In all I have the same problem, except 2.6.35 and earlier versions,
where no error occurs.

I inform you that on my laptop is connected only integrated SD card
reader (ACER 5520 with nForce 610M mother).


---------- Forwarded message ----------
From: Franco Gastón Pellegrini <francogpellegrini@gmail.com>
Date: 2011/5/3
Subject: PROBLEM: unable to enumerate USB device on port 6
To: linux-kernel@vger.kernel.org


Kernel version: 2.6.38-8-generic #42-Ubuntu SMP Mon Apr 11 03:31:24
UTC 2011 x86_64 x86_64 x86_64 GNU/Linux

hi,
I have an ACER 5520, with ubuntu 11.04 and all my TTY repeats
indefinitly (every 1/3 seconds) the mesages:

.....
May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.350128] hub 1-0:1.0:
unable to enumerate USB device on port 6
May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.610230] hub 3-0:1.0:
unable to enumerate USB device on port 6
May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.890098] hub 1-0:1.0:
unable to enumerate USB device on port 6
May 1 18:34:28 franco-Aspire-5520 kernel: [ 889.150111] hub 3-0:1.0:
unable to enumerate USB device on port 6
....

i cant use any TTY, how can i fix it? any kernel before do this for me.

PD: what info do you need to complete my report?

Excuse my english
