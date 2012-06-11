Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2FKRRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:17:42 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44085 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154Ab2FKRRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:17:40 -0400
Message-ID: <4FD6280B.2030105@mvista.com>
Date: Mon, 11 Jun 2012 21:16:59 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Anil Nair <anilcoll90@gmail.com>
CC: prasannatsmkumar <prasannatsmkumar@gmail.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Break point not hit while debugging linux kernel with kgdb
References: <CANc+2y48M+K4jvGEes_srYO7rCQcPt4pvcxcvm-Hd+7kKJr6BQ@mail.gmail.com> <CAHkwNT=3dGTZTDWi+r7m=K=Pqgv6Txi-xKcpN_pNUJ_WbUaD4w@mail.gmail.com> <4FD39A7F.9020106@mvista.com> <CAHkwNT=DLCm_gfubGV=_SahM5njpA=Z_miA=SEkVeYA9cHMdmA@mail.gmail.com>
In-Reply-To: <CAHkwNT=DLCm_gfubGV=_SahM5njpA=Z_miA=SEkVeYA9cHMdmA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-06-2012 8:30, Anil Nair wrote:

> On Sun, Jun 10, 2012 at 12:18 AM, Sergei Shtylyov<sshtylyov@mvista.com>  wrote:

>>    Yeah, KGDB was accepted into kernel exactly for more "poorly fixed
>> patches" to appear. :-)

> I was under the impression that maintainers would never recommend
> kgdb, so never learned to use it.
> If you could guide me and Prasanna on how to use kgdb that would be
> helpful :).

    For the starters, Prasanna should ask his KGDB question in the right 
mailing list, kgdb-bugreport@lists.sourceforge.net.

> If you were saying it sarcastically, then i failed to
> understand it . :P.

    Yes, there was sarcasm. If KGDB was only providing for "poorly fixed 
patches", it would have been hardly included in the kernel.

>>> You have to use gdbserver

>>    gdbserver is only good for debugging the applications.

> I never knew that..!.

    Besides, there's not much difference between remotely debugging 
applications via gdbserver and remotely debugging kernel via KGDB.

WBR, Sergei
