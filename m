Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1HZI52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:57:28 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63360 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1HZI5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110825154705.GA6567@kroah.com>
References: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>
	<20110825154705.GA6567@kroah.com>
Date: Fri, 26 Aug 2011 10:57:25 +0200
Message-ID: <CACna6ryfHpSkTtnyMUXShyZvN2quD3w8higymGGXfXsu3f1GEA@mail.gmail.com>
Subject: Re: [PATCH] staging: brcmfmac: Consolidate debugging macros
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Joe Perches <joe@perches.com>, Henry Ptasinski <henryp@broadcom.com>,
        linux-kernel@vger.kernel.org, Brett Rudley <brudley@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        devel@linuxdriverproject.org, Greg KH <gregkh@suse.de>,
        Kan Yan <kanyan@broadcom.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/25 Greg KH <greg@kroah.com>:
> On Wed, Aug 24, 2011 at 11:16:48PM -0700, Joe Perches wrote:
>> Convert multiple BRCMF_<debug_level> macros to a single
>> brcmf_dbg(level, fmt, ...) macro.
>>
>> Remove the now unnecessary double parentheses in the uses
>> of the old macros when converting to brcmf_dbg.
>>
>> Delete all uses of "%s: [fmt]", __func__, args... and move
>> the "%s: ", __func__ to the macro for consistency.
>>
>> Coalesce long formats.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>
> Applied, thanks.

You didn't give even 24h before applying :|

(Unless this patch was already posted somewhere else with RFC?)

-- 
Rafał
