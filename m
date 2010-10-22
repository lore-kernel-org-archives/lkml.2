Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0JVXyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0JVXyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oUo8jPz2HV0DKL7Pm1mR5Lkf7DpQWT6EPL+tsk42Zmo8epijAK8tMSenr2AxM6Tg9F
         9AjVQvouHXSrq1G7xc+I0rYPnMKgFACps7yymosTXEDEsXeidUUrD1o9MrlkoTcH2nnw
         0I54g1Km2n+wMEA11vxTFSbtBFCIYlEsESkcM=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/29] My patch queue for memorystick subsystem
Date: Sat, 23 Oct 2010 01:53:28 +0200
Message-Id: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As requested, this is split up series of the work I did for the
memorystick subsystem.

All patches compile tested.
All patches except jmicron patches also run tested on my r592
The end result of jmicron patches is exactly the same as my old patch
that did work very well. I will test the patches tommorow though to ensure that
all of them work for bisectability.

Please review & merge.

Best regards,
	Maxim Levitsky


