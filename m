Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2AZKGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:06:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab2AZKGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:06:45 -0500
Message-ID: <4F2125B3.4070000@suse.cz>
Date: Thu, 26 Jan 2012 11:06:43 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: fix new choices being skipped upon config update
References: <20120120164036.GO4066@pengutronix.de> <1327357745-9095-1-git-send-email-lacombar@gmail.com> <20120126092603.GQ6305@pengutronix.de>
In-Reply-To: <20120126092603.GQ6305@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.1.2012 10:26, Uwe Kleine-König wrote:
> On Mon, Jan 23, 2012 at 05:29:05PM -0500, Arnaud Lacombe wrote:
[...]
>> will not cause the choice to be considered as NEW, and thus not be asked. The
>> cause of this behavior is that choice's novelty are computed statically right
>> after the saved configuration has been read. At this point, the new dependency's
>> value is still unknown and asserted to be `no'. Moreover, no update to this
>> decision is made afterward.
>>
>> Correct this by dynamically evaluating a choice's novelty, and removing the
>> static evaluation.
>>
>> Cc: linux-kbuild@vger.kernel.org
>> Cc: LKML <linux-kernel@vger.kernel.org>,
>> Cc: Michal Marek <mmarek@suse.cz>
>> Cc: Uwe Kleine-Konig <u.kleine-koenig@pengutronix.de>
>> Reported-by: Uwe Kleine-Konig <u.kleine-koenig@pengutronix.de>
> Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks, applied to kbuild.git#kconfig.


> (Please note the umlaut o in my name. If you have problems with that,
> please at least write Kleine-Koenig.)

Fixed.

Michal
