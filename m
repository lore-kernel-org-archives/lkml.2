Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1CYR4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:56:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60790 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1CYR4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:56:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=VJICG35GiaqksCYKiNFKRGQRm1H9ap23IhRi4rSfAR0zj/xNY6xsbtzb88NWlattKK
         mekqKsMin745SOwCuzpzxSM1BVMu67f2Ewj8r8mOLa49nebiX6z1dUvalNpIn1RpO40L
         WuN3UOGaRM6hUFB5S/MS4b8MDmusUb13UmGOE=
MIME-Version: 1.0
In-Reply-To: <AANLkTik9+Dbo5gMFivxT-+geay=zqbihhkTU2M5QkV9S@mail.gmail.com>
References: <AANLkTik+j-gyEcdmXFg66qbDjQP7E6ru24foV-pduMhk@mail.gmail.com> <AANLkTik9+Dbo5gMFivxT-+geay=zqbihhkTU2M5QkV9S@mail.gmail.com>
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Fri, 25 Mar 2011 22:26:15 +0430
Message-ID: <AANLkTi=i05vZuTK=MGQeLMoC-iOBebrm-GNon2JQnM5+@mail.gmail.com>
Subject: Re: Toggled breakpoint before start debugging doesn't work!
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would you please reply me? I get kernel oops, and I want to find out
where is the problem.
Thanks,

On Fri, Mar 25, 2011 at 7:49 PM, Amirali Shambayati
<amirali.shambayati@gmail.com> wrote:
> ---------- Forwarded message ----------
> From: Amirali Shambayati <amirali.shambayati@gmail.com>
> Date: Fri, Mar 25, 2011 at 7:20 PM
> Subject: Toggled breakpoint before start debugging doesn't work!
> To: Linux Kernel <linux-kernel@vger.kernel.org>
>
>
> Hello all,
>
> I'm using eclipse CDT connected to Qemu, to debug linux kernel code.
> My code is trapped in deadlock condition. Thus I put breakpoints in
> some functions to
> find the deadlock point, but as I toggle them before start debugging(F11), It
> doesn't stop at breakpoints and goes to deadlock again. Generally if I toggle a
> breakpoint after start debugging, it stops there. Would you guide me what is my
> fault?
>
> --
> Amirali Shambayati
> Bachelor Student
> Computer Engineering Department
> Sharif University of Technology
> Tehran, Iran
>
>
>
>
> --
> Amirali Shambayati
> Bachelor Student
> Computer Engineering Department
> Sharif University of Technology
> Tehran, Iran
>



-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
