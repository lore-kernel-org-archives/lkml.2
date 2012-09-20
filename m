Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2ITHoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:44:34 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3959 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab2ITHoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:44:32 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <505AC952.60501@broadcom.com>
Date: Thu, 20 Sep 2012 09:44:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827
 Thunderbird/15.0
MIME-Version: 1.0
To: "Nico Schottelius" <nico-kernel20120920@schottelius.org>
cc: "David Rientjes" <rientjes@google.com>, linux-kernel@vger.kernel.org,
        "Stanislaw Gruszka" <sgruszka@redhat.com>
Subject: Re: Out of memory on 3.5 kernels
References: <20120920060202.GB10758@schottelius.org>
 <alpine.DEB.2.00.1209192351440.30029@chino.kir.corp.google.com>
 <20120920073245.GA1327@schottelius.org>
In-Reply-To: <20120920073245.GA1327@schottelius.org>
X-WSS-ID: 7C44168F3P84754474-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 09:32 AM, Nico Schottelius wrote:
> Hey David,
>
> David Rientjes [Wed, Sep 19, 2012 at 11:54:54PM -0700]:
>> >On Thu, 20 Sep 2012, Nico Schottelius wrote:
>> >
>>> > >for some time the slab usage is quite high (~3.2 GiB) and whenever I try
>>> > >to do a backup with ccollect (which is using rsync), a lot of processes
>>> > >(like chromium) are being killed over night.
>>> > >
>> >
>> >Yeah, over 81% of your memory is consumed by slab and that doesn't shrink
>> >over the duration of the log you posted.  It would be interesting to see
>> >if there was a leak somewhere: try looking at slabtop and determining if
>> >you have a cache using an egregious amount of memory;
> I already had to reboot, because no now process was starting / only
> starting extremly slowly.
>

Hi Nico,

Being curious (and suspicious) over here. Are you doing the rsync over 
wireless interface using brcmsmac? I am currently looking at bugzilla 
#47721 (see [1]) and maybe this is related.

Gr. AvS

[1] https://bugzilla.kernel.org/show_bug.cgi?id=47721

