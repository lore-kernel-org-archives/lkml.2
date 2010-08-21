Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab0HUR4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:56:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48033 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0HUR4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kTJsw+IWJ+U+LLGob+NrKDVNvr5oJF5VavMopJKoxTaJ4zQn9BNWX/FtuCeY1F/U1y
         Egcs8mio8WcnLyNu1S7TtkFm/+D9Pzf2weLgqqXl+xX/ZIig6IG0364uZPhjfmUZte9s
         ih98Hqr3gPWU1BaQ1C3jAMmXOJ2M0xs593k1M=
MIME-Version: 1.0
Date: Sat, 21 Aug 2010 13:56:19 -0400
Message-ID: <AANLkTi=9y=_NnC349523E_qgJ2nSk1++3Z_Phx+GMJW4@mail.gmail.com>
Subject: How the heck do I get started?
From: Someone Something <fordhaivat@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I am a pretty so so C programmer (I've written small networked stuff,
a simple game engine, GUI tools etc.), I just do programming as a
hobby and I'm a middle school student. I am interested in low level
programming and I dabble in assembly, so, I downloaded the latest
kernel source and the sheer size of it just blows my mind. How should
I get started hacking on it? Writing modules, or just browsing through
the code and trying to understand it? Any books you guys recommend?
I'm pretty sure that you're sick and tired of these newb questions,
so, I actually did some research, and I do have a few concrete
questions.
1) Does the linux kernel use pages AND segments? Or just one of them?
If its pages, how does it deal with the wasted memory at the end of
each page? Very small pages?
2) I looked at the 0.01 kernel and it has this weird mix of nasm and
gas syntax for its assembly. Why's that?
3) Is there some kind of tracker for the kernel where it lists bugs and stuff?
4) If I do have a patch I'd like to submit, how would I do this?


Thanks a lot,
Dhaivat
