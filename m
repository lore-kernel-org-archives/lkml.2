Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0HRNaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:30:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54179 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0HRNaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=p4tSrOz5B0/FmvB6TepVNI35JDQ7UbaHxDkv1YBqmB5DJtmmhW6irc7blI/eU9OsFt
         UE5Vuy10o7lMyLui0OAKv1LsRUhcLFJqLNQPcYVmcsEKJOaoy9G3lSXz2ZyEhImi7n3I
         XHSBgyVq65dL4/mcdy56DA+jDCmAGIwUJe9Xc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikPC1CGjNcP2ARf8SJw3HTEBOcdgGnDjx87DERX@mail.gmail.com>
References: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com>
	<201008180325.17816.rjw@sisk.pl>
	<AANLkTimdF_eYurw9k0rQRAzSQ-fZMKsFLupnME_ch1Ru@mail.gmail.com>
	<alpine.LNX.2.00.1008180911180.1019@pobox.suse.cz>
	<AANLkTiki82ZFntH2M6UTyB7+215=4mNmk3SsxiS=CGDH@mail.gmail.com>
	<alpine.LNX.2.00.1008181045110.1019@pobox.suse.cz>
	<AANLkTikPC1CGjNcP2ARf8SJw3HTEBOcdgGnDjx87DERX@mail.gmail.com>
Date: Wed, 18 Aug 2010 15:30:20 +0200
X-Google-Sender-Auth: 9Z1yODg6SK_uHAjTK0CAsOAH9hU
Message-ID: <AANLkTimSkniqYYWAD29VK6Rt45b_5A84fuK0m0q9EznC@mail.gmail.com>
Subject: Re: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: trapdoor6@gmail.com
Cc: Jiri Kosina <jkosina@suse.cz>, osnix0@googlemail.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        arnd@arndb.de, trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/18 trapDoor <trapdoor6@gmail.com>:
> Andrea, Gabriel
> Would you please check if Jiri's patch solves the problem on your end
> as well? Just to make 100% sure we can close related bugzilla call.

Well, I made the test, with ~10 cycle hibernation/resume.
Everything seems goes right.

Thanks a lot for your work,
Andrea
