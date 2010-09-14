Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab0INXGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:06:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53206 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab0INXGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DWuG0Ba3VAFbI3HLdNWqRdDQ/XcZ69zRlAm6d9PCmyPh+k09fYnsnH/Q7doqTM3hVl
         N8F6jSjSSWvkcz4v5aywGL1MWER+qmooFT0WxNSO4q08JfRtM8mO7oWJQCFJZaStDlxN
         SyOljGRvRzGKP6PqVZJ3HNrAz6wmT1J+mrb6E=
Message-ID: <4C900007.1000806@gmail.com>
Date: Tue, 14 Sep 2010 16:06:47 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Nigel Cunningham <nigel@tuxonice.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.36-rc3 - Unable to build: "Error: input truncated"
References: <4C8CB5A1.9040500@tuxonice.net>	<201009121934.37033.rjw@sisk.pl>	<4C8D5D41.90104@tuxonice.net> <20100912201152.a4ada04a.randy.dunlap@oracle.com> <4C8DB031.6050008@tuxonice.net> <4C8DB674.5040200@gmail.com> <4C8DC01A.4030206@tuxonice.net> <4C8DC6B9.3050701@gmail.com> <4C8DCA43.5000608@tuxonice.net> <4C8DD067.6060005@gmail.com> <4C8FFCC6.1000806@tuxonice.net>
In-Reply-To: <4C8FFCC6.1000806@tuxonice.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 03:52 PM, Nigel Cunningham wrote:
> Hey all.
>
> It was corruption in my ccache cache. I eventually found that ccache -S
> and make distclean (or git clean -fx) together make it work again.
>
> Sorry for the noise. Perhaps, though, this will help someone in future :)
>
> Nigel
>


yeah same happened here.. bisecting this got me pushed all the way back 
in May(even though in May everything was fine all the way up too present)..

glad your up and running..

Justin P. Mattock
