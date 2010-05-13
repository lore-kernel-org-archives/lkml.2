Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab0EMScp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:32:45 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54449 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab0EMSco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:32:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=jl866jnocNjEcnPiryKw8+MzZT6PINTM8vOFAuzp84abGDIvcrFhR2bC963jy1tQmM
         V9ZPqczsKHYkPzJ1xLVY936Hzwzdh+uwa+9IEcbhW3N4x+XPllEjLM19ya2bJ7JIhS7b
         EQmdDzewLl0vvi3DWxcYYujquS2tFNXmekMgQ=
MIME-Version: 1.0
Date: Fri, 14 May 2010 00:02:43 +0530
Message-ID: <AANLkTinbwZK5Tp6aI4ja38XaiiB5aIyECzHPdMpvkaIy@mail.gmail.com>
Subject: preempt_disable and sleep()
From: ratheesh k <ratheesh.ksz@gmail.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running RT linux .

/* code snippet */

preempt_disable()
...........
sleep(10);
'............
preempt_enable()


will this sleep() will cause reschedule ?.

if an interrupt comes  while premption is disabled , how it is handled ?.

Thanks,
Ratheesh
