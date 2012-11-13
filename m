Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2KMDh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:37:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65180 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2KMDht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:37:49 -0500
Message-ID: <50A1C083.6080904@vlnb.net>
Date: Mon, 12 Nov 2012 22:37:39 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Howard Chu <hyc@symas.com>
CC: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vladislav Bolkhovitin <vst@vlnb.net>, "Theodore Ts'o" <tytso@mit.edu>,
        drh@hwaci.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org> <508B3EED.2080003@vlnb.net> <20121027044456.GA2764@thunk.org> <5090532D.4050902@vlnb.net> <20121031095404.0ac18a4b@pyramind.ukuu.org.uk> <5092D90F.7020105@vlnb.net> <20121101212418.140e3a82@pyramind.ukuu.org.uk> <50931601.4060102@symas.com>
In-Reply-To: <50931601.4060102@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:oewUXUDSLPlySju8A9iwDBi3ZKHCbSOn77+69jEIHBD
 LGvJjW9wXkBn15zmhwWkph7N28DepI0daI+oFv1ue56NZzxGiA
 LohwxO982J5Eq35QLJ2F6YtGAHrTHGJ81He3WQKzBlBvRsUUU2
 o6+AGjKLfQJnthcPgVi9VlKNNAqjYIoyx8+vd4hf/7fLsXnmfK
 ZYJgLTjKu4WLLJrfNYoHrxw/aYt3Aq063FH1leMnPpEQsUedZC
 mdY2HH6+VRrjIvK7b1zrj/Nhvaco5rgNPhf4Tj3IEQUTt16F3I
 WfHPIQrNaHx0BsENc5/0k63u7yCCYITwB2DkJ86bvRYM6QeS2N
 XilSwKffmel0b9Q/2MBc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Howard Chu, on 11/01/2012 08:38 PM wrote:
> Alan Cox wrote:
>>> How about that recently preliminary infrastructure to send ORDERED commands
>>> instead of queue draining was deleted from the kernel, because "there's no
>>> difference where to drain the queue, on the kernel or the storage side"?
>>
>> Send patches.
>
> Isn't any type of kernel-side ordering an exercise in futility, since
> a) the kernel has no knowledge of the disk's actual geometry
> b) most drives will internally re-order requests anyway
> c) cheap drives won't support barriers

This is why it is so important for performance to use all storage capabilities. 
Particularly, ORDERED commands instead of trying to pretend be smarter, than the 
storage, doing queue draining.

Vlad
