Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab0HNTBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 15:01:31 -0400
Received: from mxo.volny.cz ([195.250.128.90]:55767 "EHLO mxo.volny.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab0HNTBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 15:01:30 -0400
MIME-Version: 1.0
Subject: =?iso-8859-2?Q?Re:_Linux_2.6.35.2?=
From: wylda@volny.cz
X-Originating-Account: wylda/volny.cz
To: torvalds@linux-foundation.org, edt@aei.ca, sedat.dilek@gmail.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, penberg@kernel.org,
        arthur@psw.ro
Date: Sat, 14 Aug 2010 21:01:25 +0200 (CEST)
Message-ID: <41235f88819cbc4a7586e3baa1148383@www3-mail.volny.cz>
X-Mailer: Volny.cz Webmail2 2.147
X-Originating-Ip: 77.48.63.226
X-Originating-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; cs; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 (.NET CLR 3.5.30729)
X-Webmail2-Origin: wylda/volny.cz [77.48.63.226]
X-Priority: 3
In-Reply-To: <AANLkTingwMvoVm_J6cmm_K3=G9rCYwOrQ=-5vK_wzGcX@mail.gmail.com>
References: <AANLkTimNborh0AtHkdnN-aCizDu4+S6ORmeoKzS_nEVH@mail.gmail.com> <AANLkTikNTZSqZ-sa0uGY0FnjDnOziu4qR8fEitD2TPQc@mail.gmail.com> <AANLkTi=TNsb_JaP0_us8C0XQwRK3qaUdviA-YxcwT223@mail.gmail.com> <201008141427.03946.edt@aei.ca> <AANLkTingwMvoVm_J6cmm_K3=G9rCYwOrQ=-5vK_wzGcX@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Just to verify: you have CONFIG_HIGHPTE enabled on a x86-32
> kernel,
> > right? I'd have expected this to not ever show up anywhere else,
> and
> > I'm just verifying that there isn't anything else going on. I'm
> appending the commit message, the patch hasn't changed.
> 
> Linus
> ---

I know it didn't belong to me, but i can also confirm: 32bit kernel
here
and CONFIG_HIGHPTE=y.

Regards,
W.

