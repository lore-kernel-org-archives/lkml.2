Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0LJSNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:13:24 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:54882 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566Ab0LJSNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:13:23 -0500
Message-ID: <4D026DB1.8070100@euromail.se>
Date: Fri, 10 Dec 2010 19:13:05 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Interface and MT_TOOL documentation updates
References: <1291929732-5989-1-git-send-email-rydberg@euromail.se> <AANLkTi=mqMY_VG=0RdN5O0fDh6wpTRb5Z59L6440hvX6@mail.gmail.com>
In-Reply-To: <AANLkTi=mqMY_VG=0RdN5O0fDh6wpTRb5Z59L6440hvX6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PR7Ss-0005cr-Ce.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PR7Ss-0005cr-Ce 52d0e699f3c917fe8c19730b8de94606
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> Can we make MT_TOOL_ENVELOPE cover a bit more cases by:
> 
> 1. Removing ", and is only used for legacy hardware";
> 2. Adding "Or the number of contacts inside the bounding rectangle is
> reported if hardware provides the number but not the real contact
> positions" to the end of the paragraph.


You might disagree, but "old" is still somewhat apt in this situation. How would
you suggest we report the number of fingers?

Henrik
