Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab0DPOeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:34:19 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:48187 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555Ab0DPOeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:34:17 -0400
Message-ID: <4BC87439.3010206@euromail.se>
Date: Fri, 16 Apr 2010 16:29:13 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: Michael Poole <mdpoole@troilus.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: mt: introduce MT event slots
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se>	<87tyrmiqw2.fsf@troilus.org> <4BBDA555.1020003@euromail.se> <87mxxei33o.fsf@troilus.org> <4BBDD3B1.6030808@euromail.se> <544AC56F16B56944AEC3BD4E3D5917712E567F0FEB@LIMKCMBX1.ad.analog.com>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D5917712E567F0FEB@LIMKCMBX1.ad.analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.129.72
X-Scan-Result: No virus found in message 1O2mXl-0007MM-7A.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1O2mXl-0007MM-7A 1f6cb49abdc8a2725d7534a8d22950e2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hennerich, Michael wrote:
[...]
> 
> Sorry, I must have missed something -
> What is ABS_MT_USER_ID?

Oh, it just served as an example of possible future extensions, it is not part
of the current MT protocol. Sorry about the confusion.

Cheers,
Henrik

