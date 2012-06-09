Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2FKOJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:09:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2FKOJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:09:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 0/6] drivers: randconfig patches for kernel 3.5
Date: Sat, 9 Jun 2012 21:28:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: mathieu.poirier@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        unsik Kim <donari75@gmail.com>
References: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org> <201206090013.27149.arnd@arndb.de> <4FD3482B.5050004@gmx.de>
In-Reply-To: <4FD3482B.5050004@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206092128.45064.arnd@arndb.de>
X-Provags-ID: V02:K0:24RLZxJVPcu9g+ztmKIrn5RkZ6Q5K9FCPY85oV6+0if
 K9VnKAmTMtq+JZY+QixBz4qT5W2xtLkL6jSPJdgCCVPgKNtZHw
 sYXDRyFbYJSqhO2FJ2A9QQvcgU6snaAGT82CE2XtqlPNUrmY1e
 aP/olfltSQLmxQjIP0AvflmyJTCI820QPxx+GLhxkmme5mGw/3
 0XdqoHUsyB2lIWSHt1m5xj986X9w3UM9LPeTybWSNWmFZkTwBR
 BC1XW8YXfb2ATo2NFACpcp9GljmRpzSJI74QdHmCMMk3hKrnq8
 8xfZ+tLnsqRohRBO8E/OJi8JBrYDOfHIu/F0aVkCEY2vBvM7EQ
 0gOr+vbLXBNMOJt2le6o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 June 2012, Florian Tobias Schandinat wrote:
> > 
> > I just realized that most of these are for the same subsystem
> > (framebuffer), so you should have kept the respective mailing list
> > and maintainer on Cc (added now). 
> > 
> > The mg_disk driver is not listed in the MAINTAINERS file but
> > has an author email listed in the file itself.
> > 
> > I can take the mg_disk patch into the arm-soc tree as a fix,
> > but I'd prefer the other patches to go through the framebuffer
> > tree.
> 
> Applied all (including the backlight patches which are usually handled
> by Andrew Morton) but the mg_disk patch.

Ok, Thanks a lot!

	Arnd

