Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0E3Xmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 19:42:46 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40506 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab0E3Xmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 19:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=qtGy2IRLaCQJt82Vz1NdDR7iZ+TSLlrDmebjB6xSUww5JuQQrwAio5NQ2znQsWQkXM
         pmq16j8hQSxZw6xWpPpoOlki1BetoPavbvIl8puR/YMoUn5EjcYkchmYLK7df7LR/ZCP
         fjXo9OHFVORrJHRvb4aM+pB3nlSsFhJ51CPcg=
From: Eric Lacombe <goretux@gmail.com>
To: Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Intel Arrandale IGP - screen does not light up on resume
Date: Mon, 31 May 2010 01:42:39 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-custom; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005310142.40209.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got a problem with my laptop (powered by i7 Arrandale, it's a Sony Vaio 
Z11Z9E), when I resume from "suspend to ram" my screen does not light up. X 
uses the Intel IGP.
Maybe it is an issue with the driver of the IGP of the Core i7 Arrandale?

I currently use Linux 2.6.34, and have tested 2.6.33 and 2.6.32 (I see on 
google that there were some problems about Intel IGP and blackscreen. I was 
hit by them too at that time)

If you have any suggestions or if you want me to test any patch, I would be 
glad to do so.
Feel free to ask me any information I could provide to you about this problem.

Best regards,

	Eric
