Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1I1Ujs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 16:39:48 -0400
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:48238 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1I1Ujq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 16:39:46 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Sep 2011 16:39:46 EDT
Subject: Re: [PATCH 0/2] autodetection of multitouch devices
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <alpine.LNX.2.00.1109261644250.24692@pobox.suse.cz>
Date: Wed, 28 Sep 2011 22:32:26 +0200
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        USB list <linux-input@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D3E37531-860E-415F-B2B9-58CEBB4E10A3@enac.fr>
References: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com> <alpine.LNX.2.00.1109261419330.13109@pobox.suse.cz> <20110926144635.GA6921@polaris.bitmath.org> <alpine.LNX.2.00.1109261644250.24692@pobox.suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 26 sept. 2011 à 16:47, Jiri Kosina a écrit :

> On Mon, 26 Sep 2011, Henrik Rydberg wrote:
> 
>>>> These two patches finally enable the kernel to handle multitouch devices correctly.
>>>> If a device presents in its report descriptors the usage Contact ID, then it is considered as
>>>> a multitouch device and handled by hid-multitouch.
>>> 
>>> Hi Banjamin,
>>> 
>>> thanks a lot for working on this. I have now queued the patches in my 
>>> tree.
>> 
>> Hi Benjamin,
>> 
>> Late as it seems, here are a couple of questions:
>> 
>> 1. How was this tested? By removing all white-listed devices in
>> hid-multitouch.c to see if the usual suspects are still picked up?
> 
> If we didn't have full test coverage (which I suppose to be the case), we 
> can still revert to the old method after the merge window if there reports 
> that this broke things on particular devices.
> 
> Do you guys at least have report descriptor dumps from most of the 
> supported devices?


Yes, we have report descriptors for about 20-30 different models now, and about 10 actual devices for testing purposes. Unfortunately, this still does not tell us exactly how all these devices manage to work with the same Win 7 driver, given their diversity. We are getting close, but just not yet.

BTW we gladly accept to receive sample panels from vendors, this usually ensures fast support. Additionally, the panels are then reused by ENAC students in their projects, so this stimulates the market of multitouch devices in aviation :-)

Cheers,

St.


