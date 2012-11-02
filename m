Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab2KBAQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:16:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58416 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2KBAP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:15:57 -0400
Message-ID: <509310A8.6010607@vlnb.net>
Date: Thu, 01 Nov 2012 20:15:36 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net>	<20121025051445.GA9860@thunk.org>	<508B3EED.2080003@vlnb.net>	<20121027044456.GA2764@thunk.org>	<5090532D.4050902@vlnb.net>	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>	<5092D90F.7020105@vlnb.net> <20121101212418.140e3a82@pyramind.ukuu.org.uk>
In-Reply-To: <20121101212418.140e3a82@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:lx2Q34Gk3yrJkIG7Qs5VFSk9ohawD9UtJwvLSzQsuXk
 qEy1N6Jia+hOGzwGRcp/qT4hk9KyNDmv1QzNYJG4dEnvqXXAtm
 mmf4wxK1RbO/EKeLcgg4YNnj7XQGp4DFyWnbajQjHHWOZAsHuh
 gCTUgPZGONCwgqRc6EVY/m5bfeoNo1iTaa4l5BphCavs7iLw+h
 bbgIIa3L5l6c9HVFogwfVQu8NLflEeBPLpkm5VKCb4orgS9a90
 i4zLdmoU9at1l0H4CIJsGilL87oBBirN/yOULlgbUV49gcTOD4
 4y3pG5VY19epaIMl2K7EyI9QataS4WX6NQABWxJZ739Ygtq2gk
 EvlDiRNoiYya/gHa5o6U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Cox, on 11/01/2012 05:24 PM wrote:
>> How about that recently preliminary infrastructure to send ORDERED commands
>> instead of queue draining was deleted from the kernel, because "there's no
>> difference where to drain the queue, on the kernel or the storage side"?
>
> Send patches.

OK, then we have a good progress!

Vlad
