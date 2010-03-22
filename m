Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0CVTTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:19:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41991 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab0CVTS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=d73iH5k5hQcCj/itdfFBXSCE+uvcZ4eVXuesbPi+iqmhFVEQVMwE4PvaaIzq7d9FRw
         BCPv/JQNldo2htbYekSMd2t2TO0T46mUKuaO2eQRsfwGSUjMeu1wjCeygJBNDb71o1bK
         JKbbMqrO0mTYNQS83ZFnKA87+Khsgn1eOF3/U=
MIME-Version: 1.0
Date: Mon, 22 Mar 2010 20:18:49 +0100
Message-ID: <c384c5ea1003221218o2dfcf445s8b7fd5c08076bdab@mail.gmail.com>
Subject: Memory-mapped I/O barriers, state of affairs?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

searching for good info on device IO racing against host memory writes
I came upon this 2006 article:

http://lwn.net/Articles/198988/

"there is no guaranteed ordering between writes to regular memory and
writes to a memory-mapped I/O range. "

What is the current solution for that particular problem, i.e. how
should I make sure host memory writes are committed before I have an
external DMA device act on it?

Thanks,
-- 
Leon Woestenberg.
