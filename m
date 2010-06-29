Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab0F2MkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:40:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:19701 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0F2MkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:40:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YKAJdj7i/+Ql7cXOWbiHUB0LiVYt8+aPa978GvtJARh2uRUMtb3S7XHghBSGXptMXl
         3D/kWaGdl6sNXZ+2vwgE8V9FZGEomDyGxW0QLnMXMhVLJuiWVTZcl7HsOtnJKKFydt2p
         BffDtHt9FEE/DiJ17ntG95vrFqpaHfXIfL0Xk=
MIME-Version: 1.0
In-Reply-To: <20100629.001216.91341775.davem@davemloft.net>
References: <1276467601-9066-1-git-send-email-alan@signal11.us>
	<20100628131437.bde782b6.ospite@studenti.unina.it>
	<20100629.001216.91341775.davem@davemloft.net>
Date: Tue, 29 Jun 2010 15:40:10 +0300
Message-ID: <AANLkTiktvYWdZmpQs_k7mJRqMCqgfhy1b0T8tX8emmtU@mail.gmail.com>
Subject: Re: [PATCH 1/1] Bluetooth: hidp: Add support for hidraw 
	HIDIOCGFEATURE and HIDIOCSFEATURE
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: ospite@studenti.unina.it, alan@signal11.us, marcel@holtmann.org,
       jkosina@suse.cz, mdpoole@troilus.org, hadess@hadess.net,
       eric.dumazet@gmail.com, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 29, 2010 at 10:12 AM, David Miller <davem@davemloft.net> wrote:
> From: Antonio Ospite <ospite@studenti.unina.it>
> Date: Mon, 28 Jun 2010 13:14:37 +0200
>
>> On Sun, 13 Jun 2010 18:20:01 -0400
>> Alan Ott <alan@signal11.us> wrote:
>>
>>> This patch adds support or getting and setting feature reports for bluetooth
>>> HID devices from HIDRAW.
>>>
>>> Signed-off-by: Alan Ott <alan@signal11.us>
>>> ---
>>
>> Ping.
>
> We effectively don't have a bluetooth maintainer at the current point
> in time.  I've tried to let patches sit for a while hoping the listed
> maintainer would do something, at least occaisionally, but that simply
> isn't happening.
> So I'll just pick patches up directly as I find time to review them,
> but I have to warn that for me it's going to be done in a very low
> priority way because I really don't find bluetooth all that exciting. :-)

This would be good. We have a backlog of bluetooth kernel patches
waiting for several months.
This takes too much time to return to them again and again...

Please keep this ML informed.

Regards,
Andrei Emeltchenko
