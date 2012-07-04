Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2GDLvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:51:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab2GDLva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:51:30 -0400
Message-ID: <4FF42E37.50009@redhat.com>
Date: Wed, 04 Jul 2012 13:51:19 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Hugh Dickins <hughd@google.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Joe Thornber <ejt@redhat.com>,
        LVM general discussion and development 
	<linux-lvm@redhat.com>,
        amwang@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        linux-kernel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: Re: Regression with FALLOC_FL_PUNCH_HOLE in 3.5-rc kernel
References: <4FEEE5E5.5060800@redhat.com> <alpine.LSU.2.00.1206301217590.1728@eggly.anvils> <4FEF66C4.20001@redhat.com> <alpine.LSU.2.00.1206301541280.1919@eggly.anvils> <4FF04950.30503@redhat.com> <alpine.LSU.2.00.1207011112250.1799@eggly.anvils> <4FF0AEA9.3090900@redhat.com> <4FF0C91B.8050700@redhat.com> <20120702133308.GB785@redhat.com>
In-Reply-To: <20120702133308.GB785@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 2.7.2012 15:33, Mike Snitzer napsal(a):
> Not sure why you're testing such old kernels without regard for fixes
> (likely just a hopeful bisect?).
>
> In any case, you definitely need this commit (was also marked for
> stable): 0c535e0 v3.3-rc7 dm io: fix discard support
>
>

After some more crashed filesystems here is the outcome with trial patch from 
Mikulas included:


https://bugzilla.redhat.com/show_bug.cgi?id=837607


Zdenek
