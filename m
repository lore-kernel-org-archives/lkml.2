Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0HROtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:49:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48604 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab0HROs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ve6qWv8YGu3ZDd/4BFzuhI+lGdrnkU/3OyX3wKnnIzf9FTHu3GI4nQiq6qVqEtvIre
         Oc5qh8tcMXs+27dDvYlZJiaXsIuKUFIc/7PE1FeoiJXq0DhFdjBZQMPB/wiEOyLCZDO/
         PXiqeOynROvXtJ2zAXzmo9sXNvrbDcMvX19qc=
MIME-Version: 1.0
In-Reply-To: <AANLkTimSkniqYYWAD29VK6Rt45b_5A84fuK0m0q9EznC@mail.gmail.com>
References: <AANLkTimnC384BMdwJtk1Rp33YnAXr66HJqPvBegOxGmC@mail.gmail.com>
	<201008180325.17816.rjw@sisk.pl>
	<AANLkTimdF_eYurw9k0rQRAzSQ-fZMKsFLupnME_ch1Ru@mail.gmail.com>
	<alpine.LNX.2.00.1008180911180.1019@pobox.suse.cz>
	<AANLkTiki82ZFntH2M6UTyB7+215=4mNmk3SsxiS=CGDH@mail.gmail.com>
	<alpine.LNX.2.00.1008181045110.1019@pobox.suse.cz>
	<AANLkTikPC1CGjNcP2ARf8SJw3HTEBOcdgGnDjx87DERX@mail.gmail.com>
	<AANLkTimSkniqYYWAD29VK6Rt45b_5A84fuK0m0q9EznC@mail.gmail.com>
Date: Wed, 18 Aug 2010 16:48:58 +0200
Message-ID: <AANLkTikooEGbmLT-UVZ3wb1jAjocT1eO06tZkg+kQefV@mail.gmail.com>
Subject: Re: [REGRESSION, bisected] 2.6.36-rc1 - suspend issues
From: Gabriel Craciunescu <osnix0@googlemail.com>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: trapdoor6@gmail.com, Jiri Kosina <jkosina@suse.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        arnd@arndb.de, trapDoor <trapdoor6@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/18 Andrea Gelmini <andrea.gelmini@gelma.net>
>
> 2010/8/18 trapDoor <trapdoor6@gmail.com>:
> > Andrea, Gabriel
> > Would you please check if Jiri's patch solves the problem on your end
> > as well? Just to make 100% sure we can close related bugzilla call.
>
> Well, I made the test, with ~10 cycle hibernation/resume.
> Everything seems goes right.
>

Does work fine here also ..

Regards,

Gabriel
