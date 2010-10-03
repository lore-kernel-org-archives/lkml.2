Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0JCIP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 04:15:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65337 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0JCIP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 04:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lUHE35VNOrwUWsnKBA3td0bzZ4rtxiyycxgzhWG3gbdyontlfJDfWkLk9tqWY/+d2V
         F0F82LEq/rpjON04AeC3aPZNEE2yDqsl1va5i2TWdO1a75wj/5uNCaSN62cSJJLsj56L
         HcbHX2s1PQNj2YfDq8FsfNuyV7IxvmI1DK8kU=
MIME-Version: 1.0
In-Reply-To: <20100910195038.cb8c6031.krzysztof.h1@wp.pl>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<c073783271e15767124fd95ec3c1cd4dcc9004e9.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<20100910195038.cb8c6031.krzysztof.h1@wp.pl>
Date: Sun, 3 Oct 2010 10:15:56 +0200
X-Google-Sender-Auth: qwLeaWZlX66Jw_EB30FgRecWthM
Message-ID: <AANLkTin+kGaqWTm=PD7tEcnXcFk_yo4JHR=oRJO11Lva@mail.gmail.com>
Subject: Re: [PATCH 10/14] drivers/video: Removing undead ifdef ATAFB_FALCON
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 19:50, Krzysztof Helt <krzysztof.h1@wp.pl> wrote:
> On Mon, 6 Sep 2010 16:36:47 +0200
> Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de> wrote:
>
>> The ATAFB_FALCON ifdef isn't necessary at this point, because it is
>> checked in an outer ifdef level already and has no effect here.
>>
>> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
>
> Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

Applied to m68k tree, queued for 2.6.37.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
