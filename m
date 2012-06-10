Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126Ab2FJEaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 00:30:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60548 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2FJEaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 00:30:14 -0400
MIME-Version: 1.0
In-Reply-To: <4FD39A7F.9020106@mvista.com>
References: <CANc+2y48M+K4jvGEes_srYO7rCQcPt4pvcxcvm-Hd+7kKJr6BQ@mail.gmail.com>
	<CAHkwNT=3dGTZTDWi+r7m=K=Pqgv6Txi-xKcpN_pNUJ_WbUaD4w@mail.gmail.com>
	<4FD39A7F.9020106@mvista.com>
Date: Sun, 10 Jun 2012 10:00:14 +0530
Message-ID: <CAHkwNT=DLCm_gfubGV=_SahM5njpA=Z_miA=SEkVeYA9cHMdmA@mail.gmail.com>
Subject: Re: Break point not hit while debugging linux kernel with kgdb
From: Anil Nair <anilcoll90@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: prasannatsmkumar <prasannatsmkumar@gmail.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergei,

On Sun, Jun 10, 2012 at 12:18 AM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:

>   Yeah, KGDB was accepted into kernel exactly for more "poorly fixed
> patches" to appear. :-)

I was under the impression that maintainers would never recommend
kgdb, so never learned to use it.
If you could guide me and Prasanna on how to use kgdb that would be
helpful :). If you were saying it sarcastically, then i failed to
understand it . :P.

>> You have to use gdbserver
>   gdbserver is only good for debugging the applications.

I never knew that..!.

-- 
Regards,
Anil Nair
