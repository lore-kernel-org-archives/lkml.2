Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0IMGJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:09:35 -0400
Received: from tuxonice.net ([74.207.252.127]:48473 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab0IMGJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:09:34 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C8DC01A.4030206@tuxonice.net>
Date: Mon, 13 Sep 2010 16:09:30 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.36-rc3 - Unable to build: "Error: input truncated"
References: <4C8CB5A1.9040500@tuxonice.net>	<201009121934.37033.rjw@sisk.pl>	<4C8D5D41.90104@tuxonice.net> <20100912201152.a4ada04a.randy.dunlap@oracle.com> <4C8DB031.6050008@tuxonice.net> <4C8DB674.5040200@gmail.com>
In-Reply-To: <4C8DB674.5040200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 13/09/10 15:28, Justin P. Mattock wrote:
> probably the same thing I was hitting last week or similar... bisected
> resulted in crazy numbers(way back in may) long story short
> git clean -fx resolved the error over here..(so tied up with other
> things something as simple as that, I forgot)
>
> hope this helps..

'fraid not.

What I have since noticed, though, is that my currently running (2.6.34) 
.config doesn't trigger it, whereas the one with some changes I made the 
other day does. Looks like I have a couple of ways in which to find out 
the cause :)

Nigel
