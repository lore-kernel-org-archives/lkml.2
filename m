Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab0KSIlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:41:50 -0500
Received: from 5accd750.bb.sky.com ([90.204.215.80]:34883 "EHLO mayday.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751005Ab0KSIlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:41:49 -0500
X-Greylist: delayed 1129 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 03:41:49 EST
Date: Fri, 19 Nov 2010 08:22:56 +0000 (GMT)
From: Robert de Bath <robert$@debath.co.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups ... ps
 jaxk sid ... You are using the wrong number.
Message-ID: <Pine.LNX.4.61.1011190750500.8468@mayday.local>
X-Mailer: Pine for Linux
Reply-By: 01 jan 2001 00:00:00
X-Message-Flag: Linux: The choice of a GNU generation.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Please look at the result of this command ...

   ps jak sid
and
   ps jaxk sid

Notice the grouping for the SID column.

It's been proven that this patch is a good idea, but the SID number is the 
one that already provides the proper process grouping and is ALREADY
maintained by every program starter out there.

Using the SID solves the "all GUI programs are in the same group" problem
but still keeps "make -j99" in one group and different [a-z]terms in
different groups. What's more setsid(1) and setsid(2) make userspace
control really easy.

I think this means the time for allocating a new autogroup is when the
process DETACHES from a tty not when it attaches ...

PS: Not a mailing list member; CC me if you want to reply.

-- 
Rob.                          (Robert de Bath <robert$ @ debath.co.uk>)
                                              <http://www.debath.co.uk/>

