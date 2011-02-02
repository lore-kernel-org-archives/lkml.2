Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1BBHIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:08:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37567 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1BBHIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hSo0LlHQsRoemZNrEo0lvK2ne2SAV3wtH4MC/RNeeks8qmtAh6eETepoGb5g9U0kQ7
         s1lbJi+6RFS94MVZWJmu4QVMWTafnRVaKHdRVpQBncpA/4MHRwddkJmOjD7NPj7GaYAA
         mwSs9dESE3QaTEdnd0ylvbn1UyNn+DIJp29HA=
MIME-Version: 1.0
Date: Wed, 2 Feb 2011 02:08:40 -0500
Message-ID: <AANLkTim7A4q1dF9QAPux-RpatAfOVL3n6ag0MRi-vTGs@mail.gmail.com>
Subject: Regarding SIGSEGV
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

       I know that when a thread in an application do invalid memory
reference, OS generates SIGSEGV(segmentation fault) signal and
terminates application. What if we handle this signal by defining a
signal handler to perform to terminate only the thread did invalid
memory reference. So, that the application will not be terminated.
Also, is there any way, we can find when SIGSEGV is generated to get
the invalid memory reference and thread id, who caused this fault. I
know debuggers are written in such fashion. Can anyone point me to
right direction. Thanks in advance.

-- 
Regards,
Sri.
