Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0ESPA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:00:58 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:42554 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0ESPA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MRW4Wrjp33j4j5AcA0gM6DiRiG9lx5Pa3tdWy+Zq+n885REsljNXCLuBJPcSvKRuS6
         q+ehbeU6ciC3CXr0wWyfcSC3crzekMf+JR0YNqwwoW9NlsymGgiQXmX5p1kvp765xMcc
         1zFgMseoS+03ANigWYroD9UA9EOg1bv80+XxI=
MIME-Version: 1.0
Date: Wed, 19 May 2010 10:52:56 -0400
Message-ID: <AANLkTim5Yuvga5kwOFUaUgxbxzvkD9gyqiEUCN6nTs5b@mail.gmail.com>
Subject: More than 1M open file descriptors
From: John Masinter <johnmasinter@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm a software engineer and work with a fortune-500 company. We have a
line of linux-powered network security appliances and I am responsible
for Linux / OS development.
Our multi-core appliance handles a large number of low-bandwith tcp
connections, and after years of performance streamlining, we have hit
the kernel's million tcp connection limit.
Is there a kernel hack to increase the file descriptor limit beyond 1M
to that we may have more than 1M open tcp connections? If this is
discussed elsewhere, please point me in the right direction. Many
thanks to everyone that contributes to open source.
