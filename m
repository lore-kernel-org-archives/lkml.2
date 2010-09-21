Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab0IURAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:00:48 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:43681 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab0IURAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:00:46 -0400
In-Reply-To: <1283005748-3293-3-git-send-email-rydberg@euromail.se>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se> <1283005748-3293-3-git-send-email-rydberg@euromail.se>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Message-Id: <B5146B49-1D7A-4AFD-B925-3F35E83A2A96@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH 3/3] hid: 3m: Correct touchscreen emulation
Date: Tue, 21 Sep 2010 19:00:39 +0200
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 28 août 10 à 16:29, Henrik Rydberg a écrit :

> The current code sometimes misses to report the last BTN_TOUCH event
> when multiple fingers are lifted simultaneously.  With the
> introduction of MT slots, the tracking id is available to determine
> the oldest active contact. Use this information to simplify and
> correct the touchscreen emulation logic.
>

Acked-by: Stéphane Chatty <chatty@enac.fr>

Cheers,

St.

