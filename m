Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0INWw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:52:59 -0400
Received: from tuxonice.net ([74.207.252.127]:50895 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab0INWw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:52:58 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C8FFCC6.1000806@tuxonice.net>
Date: Wed, 15 Sep 2010 08:52:54 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.36-rc3 - Unable to build: "Error: input truncated"
References: <4C8CB5A1.9040500@tuxonice.net>	<201009121934.37033.rjw@sisk.pl>	<4C8D5D41.90104@tuxonice.net> <20100912201152.a4ada04a.randy.dunlap@oracle.com> <4C8DB031.6050008@tuxonice.net> <4C8DB674.5040200@gmail.com> <4C8DC01A.4030206@tuxonice.net> <4C8DC6B9.3050701@gmail.com> <4C8DCA43.5000608@tuxonice.net> <4C8DD067.6060005@gmail.com>
In-Reply-To: <4C8DD067.6060005@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all.

It was corruption in my ccache cache. I eventually found that ccache -S 
and make distclean (or git clean -fx) together make it work again.

Sorry for the noise. Perhaps, though, this will help someone in future :)

Nigel
