Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab2LDQgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:36:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab2LDQgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:36:12 -0500
Message-ID: <50BE2661.5070603@redhat.com>
Date: Tue, 04 Dec 2012 14:35:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Tim Gardner <rtg.canonical@gmail.com>, tim.gardner@canonical.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Sri Deevi <Srinivasa.Deevi@conexant.com>,
        Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>
Subject: Re: [GIT PULL] linux-firmware: cx23885: update to Version 2.06.139
References: <50BCEBCB.4080303@gmail.com> <1354597630.17107.42.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1354597630.17107.42.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-12-2012 03:07, Ben Hutchings escreveu:
> On Mon, 2012-12-03 at 11:13 -0700, Tim Gardner wrote:
>> Ben - what is your policy on extracting firmware from Windows drivers?
>
> I suppose the policy should be that the driver's licence must allow
> extracting and then distributing the result.  Which I wouldn't expect
> ever to be the case, in practice.
>
> Your commit message refers to the Hauppuage driver package at
> <http://steventoth.net/linux/hvr1800/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip>.  I didn't find any licence text, other than 'All rights reserved', in either that or the currently distributed version of the same driver <http://www.wintvcd.co.uk/drivers/HVR-12x0-14x0-17x0-33x0-44x0_1_48_29272_SIGNED.zip>.
>
>> It seems like it ought to be OK, and they _are_ the same files that are
>> covered under the license in WHENCE.
>
> I'm not sure how you can say they are the same files, as you're
> proposing to change the contents.  The copyright on the current files
> belongs to the chipset vendor, Conexant, and Hauppuage *presumably* used
> firmware supplied by Conexant, but either of them might have chosen a
> different licence for the versions in this driver package.

We shouldn't be replacing the firmwares that Conexant explicitly gave us
the rights to re-distribute by something else extracted from the
Windows drivers without redistribution rights.

Also, AFAIKT, with regards to the firmwares used on ivtv, there is a
license variant that Hauppauge gave to some distros in the past, after
getting Conexant's agreement for that. The terms used there explicitly
forbids redistribution.

So, if any of the existing firmware doesn't work, we should ask
Conexant (c/c) to send us a firmware that works, under the same terms
they gave us in the past, e. g. with redistribution rights.

Regards,
Mauro

