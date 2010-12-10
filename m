Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0LJH3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 02:29:05 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:58153 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab0LJH3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 02:29:02 -0500
Message-ID: <4D01D6AF.6010202@euromail.se>
Date: Fri, 10 Dec 2010 08:28:47 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Identify pointer emulation contact
References: <1291936745-4973-1-git-send-email-rydberg@euromail.se> <20101209234920.GA14810@core.coreip.homeip.net>
In-Reply-To: <20101209234920.GA14810@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PQxPN-0001cI-AF.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PQxPN-0001cI-AF a2ce283b79b25a4afd12b4960e09fa3d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> So how do you propose userspace will use it? Obviously it will not help
> old dumb (ST) applications and new smart applications should understand
> MT protocol and thus do not need to pay much attention to ST events
> anyway. Apparently you have some new dumb userspace in mind here?


You are right, it is a dumb idea. Consider this one dropped.

Thanks,
Henrik
