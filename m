Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422922Ab2CPOyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422911Ab2CPOym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:54:42 -0400
Message-ID: <4F63541D.2020704@redhat.com>
Date: Fri, 16 Mar 2012 11:54:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, rdunlap@xenotime.net, mchehab@infradead.org,
        perex@perex.cz, tiwai@suse.de, hjlipp@web.de, davem@davemloft.net,
        w.sang@pengutronix.de
Subject: Re: [PATCH] Remove references to /etc/modprobe.conf
References: <1331908876-1268-1-git-send-email-lucas.demarchi@profusion.mobi>
In-Reply-To: <1331908876-1268-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-03-2012 11:41, Lucas De Marchi escreveu:
> Usage of /etc/modprobe.conf file was deprecated by module-init-tools and
> is no longer parsed by new kmod tool. References to this file are
> replaced in Documentation, comments and Kconfig according to the
> context.
> 
> There are also some references to the old /etc/modules.conf from 2.4
> kernels that are being removed.
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>

>  Documentation/video4linux/CQcam.txt             |   14 +------
>  Documentation/video4linux/Zoran                 |    2 +-
>  Documentation/video4linux/bttv/Modules.conf     |    2 +-
>  Documentation/video4linux/meye.txt              |    2 +-

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Mauro
