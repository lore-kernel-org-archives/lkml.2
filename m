Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab0EYCVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 22:21:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55874 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab0EYCVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 22:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=MZUJBZtWP6shd8FDHyjziSsm61Y/u7+MvGHD0W+gsgT/gtU2XOpcl8pz0fqiUb75aZ
         NC+xLcwV/A8j2OTlJZUgsRHj9gVp4IOoQFAkLyJqffNrQfZ2nbxksWYZUTOOFBtcYZe3
         8SWxGQ8Dfbv6cn2ZHq7Ceo9qnO+eoA/CqivZ8=
MIME-Version: 1.0
In-Reply-To: <AANLkTinFt5yiINXrc9-fnUl7NiyzN42eUotFnZdcxbas@mail.gmail.com>
References: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
	 <1274726029.2091.15160.camel@rchatre-DESK>
	 <1274738896.2091.15438.camel@rchatre-DESK>
	 <AANLkTinFt5yiINXrc9-fnUl7NiyzN42eUotFnZdcxbas@mail.gmail.com>
Date: Tue, 25 May 2010 07:51:45 +0530
Message-ID: <AANLkTin0GuV28NsXwK6Pzo3cZ24Jn3WLR2YL9L660Us_@mail.gmail.com>
Subject: iwl3945 bug in 2.6.34
From: Satish Eerpini <eerpini@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, sorry, but that patch will not work on 2.6.34 since the
> feature it enables is not present there - it will be in 2.6.35 though.
> To enable the feature in 2.6.34 will take some more backporting effort
> that I'm looking into now.
>
the patch does lead to a reject, I am not very experienced with
code-fu in the kernel, and have no clue about the iwl code base, but
comparing the code from 2.6.24 and the latest compat-wireless tarball,
I found that in iwl-core.c
iwl_check_stuck_queue
iwl_bg_monitor_recover
are not present in the 2.6.34 version of the file, is there a
particular reason for doing this ?
is there a patch series/discussion I can follow to know the details on this ?
and I am trying to compile 2.6.34 by adding just these two functions
to iwl-core.c. If that works I will report back (though you might
already know if it will work or not)


Cheers
Satish


--
http://tuxitter.blogspot.com



-- 
http://tuxitter.blogspot.com
