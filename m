Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab0HQVsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:48:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63162 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0HQVs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=qE1UlCs2lsMUkFVZDbI+8NQFSCUvPlqXJdENSx+/uY+9dVxSBB+KwdqmLv6kArrl8D
         EvXpSHXZq3X/D2Kn4BbxqXpueL+iM2K0hLEBQ6q0gbDYnHjs/yjW3JFn3frcJxk149Ov
         1lx2S/vr6MCwJSESF9BSkP2l1gNaOonFeMxg0=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <AANLkTimLcgnob81vcsMiJaJhz=ruymE8-XA=XvxnY-GD@mail.gmail.com>
References: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com>
	<AANLkTimLcgnob81vcsMiJaJhz=ruymE8-XA=XvxnY-GD@mail.gmail.com>
Date: Tue, 17 Aug 2010 22:48:27 +0100
Message-ID: <AANLkTi=-0OU1UUZiUCVChy47KODYHm8dZGD5JonsNQCY@mail.gmail.com>
Subject: Re: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
From: trapDoor <trapdoor6@gmail.com>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Andrea.
Have you tried to revert the commit to see if it fixes the issue on your end?

I also have response from Gabriel Craciunescu on bugzilla
[https://bugzilla.kernel.org/show_bug.cgi?id=16615], who had the same
problem and confirmed that reverting the same commit solved it.

--
Regards
Tomasz B.



On Tue, Aug 17, 2010 at 9:54 PM, Andrea Gelmini
<andrea.gelmini@gmail.com> wrote:
> 2010/8/17 trapDoor <trapdoor6@gmail.com>:
>> Hello,
>> The merge window is closed so it's time to hunt for bugs. I've got
>> one, please find details below.
>
> Same problem here...
> But I've made no bisecting.
>
> Thanks a lot,
> Andrea
>
