Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0LJRsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:48:10 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:47490 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391Ab0LJRsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:48:09 -0500
Message-ID: <4D0267A6.5020603@euromail.se>
Date: Fri, 10 Dec 2010 18:47:18 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se>	<20101210173611.GA1630@core.coreip.homeip.net>	<4D026634.4000602@euromail.se> <AANLkTimnJpmRJCFhOvZndTmL3r21KEdqXr2Bd9ZT3kUb@mail.gmail.com>
In-Reply-To: <AANLkTimnJpmRJCFhOvZndTmL3r21KEdqXr2Bd9ZT3kUb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PR73v-0008NR-B3.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PR73v-0008NR-B3 a5e898d1434c07fc2a3ad9a95569d08a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Legacy to me implies we can upgrade, but this is hardware limitation.

>>> Can we say "rectangle corner - used by older hardware"?
>>>
>> How about "- older hw only", to stay within a single line?
> 
> Why do we suggest it will only be used by older hardware?


To limit its use - we really do not want to use anything but good contact data
anywhere, but we do not want to leave abundant (= old) hardware out, either.
Why, is there some case where it would be useful, you think?

Henrik
