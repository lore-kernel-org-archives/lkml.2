Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2HNJy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:54:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab2HNJyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:54:55 -0400
Message-ID: <502A2057.3000401@redhat.com>
Date: Tue, 14 Aug 2012 06:54:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video/mx2_emmaprp.c: use devm_kzalloc and
 devm_clk_get
References: <1344104607-18805-1-git-send-email-Julia.Lawall@lip6.fr> <20120806142323.GO4352@mwanda> <20120806142650.GT4403@mwanda> <501FD69D.7070702@metafoo.de> <alpine.DEB.2.02.1208101558100.2011@hadrien> <50295A43.30305@redhat.com> <alpine.DEB.2.02.1208132219060.2355@localhost6.localdomain6> <5029AC92.2060408@redhat.com> <alpine.DEB.2.02.1208140819400.1973@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1208140819400.1973@localhost6.localdomain6>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 14-08-2012 03:30, Julia Lawall escreveu:
>> Well, I've massively applied hundreds of patches today, but not much
>> on this driver. Maybe it is better for you to wait for a couple of
>> days for these to be at -next, or use, instead, our tree as the basis for
>> it:
>>     git://linuxtv.org/media_tree.git staging/for_v3.7
> 
> I cloned this, but it doesn't seem to contain the file:
> 
>> :~: cd staging/for_v3.7/

staging/for_v3.7 is the name of the branch ;)

So, you need to use "--branch staging/for_v3.7" on your git
clone command.

>> :for_v3.7: ls drivers/media/video/mx2_emmaprp.c
> ls: cannot access drivers/media/video/mx2_emmaprp.c: No such file or directory

PS.: I started yesterday to apply a major reorganization of the drivers
along drivers/media/. This driver is still there at the same path, but it
will be moving soon to another place.

