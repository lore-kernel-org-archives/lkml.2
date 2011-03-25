Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1CYPUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:20:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63427 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1CYPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=YxhjVJIX/F4/bTFWVewBZBj0Lz3giMKWF78+5yZWcH+0Nb6QX+UWF1hZMCWMWXiR83
         BOU/4X6YHYGFgEpWj4WYa9M+vBcgsU1z1wGFndLL4JzB4yOQAopZ8BkoOvFQ32lMLxCn
         U43PfsYrswi5zVPuSfwK34UH7xmlj4nbfsU6s=
MIME-Version: 1.0
In-Reply-To: <AANLkTik+j-gyEcdmXFg66qbDjQP7E6ru24foV-pduMhk@mail.gmail.com>
References: <AANLkTik+j-gyEcdmXFg66qbDjQP7E6ru24foV-pduMhk@mail.gmail.com>
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Fri, 25 Mar 2011 19:49:42 +0430
Message-ID: <AANLkTik9+Dbo5gMFivxT-+geay=zqbihhkTU2M5QkV9S@mail.gmail.com>
Subject: Fwd: Toggled breakpoint before start debugging doesn't work!
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Fri, Mar 25, 2011 at 7:20 PM
Subject: Toggled breakpoint before start debugging doesn't work!
To: Linux Kernel <linux-kernel@vger.kernel.org>


Hello all,

I'm using eclipse CDT connected to Qemu, to debug linux kernel code.
My code is trapped in deadlock condition. Thus I put breakpoints in
some functions to
find the deadlock point, but as I toggle them before start debugging(F11), It
doesn't stop at breakpoints and goes to deadlock again. Generally if I toggle a
breakpoint after start debugging, it stops there. Would you guide me what is my
fault?

--
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran




--
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
