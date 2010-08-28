Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab0H1RHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 13:07:14 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:44404 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab0H1RHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 13:07:11 -0400
In-Reply-To: <4C79346F.4050409@euromail.se>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>  <1283005748-3293-3-git-send-email-rydberg@euromail.se>  <2A410207-8AAA-4D5A-846A-B69F007E6800@enac.fr> <4C79346F.4050409@euromail.se>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <75AEF6DA-F09E-4B90-8E89-6F5B668724C9@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH 3/3] hid: 3m: Correct touchscreen emulation
Date: Sat, 28 Aug 2010 19:07:05 +0200
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 28 août 10 à 18:08, Henrik Rydberg a écrit :

>
> I think we use the term tracking id differently here. The  
> HID_DG_CONTACTID is
> actually the slot id, and the tracking id is a sequential number,  
> increased
> whenever the touch is new. I believe the patchset works correctly  
> as long as
> there is less than 32768 new touches before releasing the oldest  
> one. :-)

Oh, right. I definitely need to catch up with Protocol B.

Cheers,

St.

