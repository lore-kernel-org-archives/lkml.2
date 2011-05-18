Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab1EROhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:37:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35241 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208Ab1EROhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=WcwwVZv8d7CLB2VWxVY1JBWdDJhEZD5Pv3Kx0m8HNgyJULsbCvWZqRIPS3VhMYRk+q
         nYM1FwRoDCWjepp2dPqrRDHOYjSunFqe6IFgaHTOBVgw192YfWxw/WVSMr8Gjn7ds+m1
         xY/mqkz4CGy/h6YkwjjqZ4TcJKpZ9tNnQ6Lr8=
From: Stevie Trujillo <stevie.trujillo@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: How to get backtrace? modprobe -r iwlagn; modprobe iwlagn kills kernel
Date: Wed, 18 May 2011 16:37:46 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.4-ck3; KDE/4.6.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105181637.46164.stevie.trujillo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm having some problem getting a backtrace. When I do "modprobe -r iwlagn; 
modprobe iwlagn" (2.6.38.6 with Intel-1030N) the kernel crashes (sometimes I 
need to try 2 or 3 times, and sometimes the modprobe -r is the one that 
crashes).
This spams my monitor with several oops/panics before it finally dies. I can 
only see bottom of the last one, which probably isn't very meaningful.
I tried loading netconsole, but I only get one or two lines before it stops 
sending/printing.
I then tried kexec+crashkernel, but I only managed to get a backtrace for the 
last panic (which I think is just a result of memory corruption or something).
Finally I tried compiling ramoops into my kernel, but it didn't want to load 
because of "No such device".

--
Stevie Trujillo
