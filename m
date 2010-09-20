Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab0ITSWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:22:00 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:52993 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab0ITSV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:21:58 -0400
In-Reply-To: <1283005748-3293-1-git-send-email-rydberg@euromail.se>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Message-Id: <1213242F-BA51-4D3C-93F9-5CF29DEC513B@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH 1/3] hid: 3m: Adjust to sequential MT HID protocol
Date: Mon, 20 Sep 2010 20:21:51 +0200
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 28 août 10 à 16:29, Henrik Rydberg a écrit :

> The multitouch extensions to the HID protocol allows for contact
> data to be sent over several reports, which is also the case for
> the 3M M2256PW touchscreen. This patch modifies the logic to only
> synchronize the input layer when all contacts have been received.
> Consequentially, the full 60-finger capacity of the device is enabled.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-3m-pct.c |   22 ++++++++++++++++++----
>  1 files changed, 18 insertions(+), 4 deletions(-)

You can add

Acked-by: Stephane Chatty <chatty@enac.fr>

St.

