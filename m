Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0EVHoJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 03:44:09 -0400
Received: from ferdi.naasa.net ([87.106.227.76]:36560 "EHLO ferdi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab0EVHoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 03:44:04 -0400
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: =?utf-8?q?C=C3=A9dric_Godin?= <cedric@belbone.be>
Subject: Re: drm regression on resume with -rc7 (bisected to 797fd5b9dad12a100c81b5782573a41259728cb1)
Date: Sat, 22 May 2010 09:43:55 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; i686; ; )
Cc: Marek =?utf-8?q?Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
       dri-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>
References: <4BEB0EE6.1060002@belbone.be> <201005182006.45798.lists@naasa.net> <4BF6D347.9000107@belbone.be>
In-Reply-To: <4BF6D347.9000107@belbone.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201005220943.56567.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Friday, 21. May 2010 schrieb Cédric Godin:
Hi,

> Yes, now there is a patch thanks to Jerome Glisse. I tested 
it and it's
> working here.
> Maybe you could test it too ?
> 
> https://bugzilla.kernel.org/attachment.cgi?id=26484

I tested the patch and it works! Thank you for the link to the 
patch!

regards,
Jörg
