Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1G0PLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:11:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50456 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1G0PLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:11:16 -0400
MIME-Version: 1.0
In-Reply-To: <4E3014E2.40501@suse.cz>
References: <4E1D9C25.8080300@suse.cz>
	<1311634718-32588-1-git-send-email-mmarek@suse.cz>
	<CAM_iQpUEfYrrtpcRLTekSHMHrTTka6ir=z_GUUbnxuQKfY+OXA@mail.gmail.com>
	<4E2EBF63.8050208@suse.cz>
	<20110726080443.62196869.rdunlap@xenotime.net>
	<4E2F0735.1070403@suse.cz>
	<20110726112824.b357c756.rdunlap@xenotime.net>
	<CACqU3MWOjjB0RiWLWS8yf0u0gRqOL3JP0StyrtP1kbA+i92SfA@mail.gmail.com>
	<CACqU3MWopoJcd+5ELWEDp6_GvVpEjOHLnkcj4s_fHT5unp+MtA@mail.gmail.com>
	<20110726213536.1f56f0e3.rdunlap@xenotime.net>
	<4E2FCE2A.3000909@suse.cz>
	<CACqU3MX7p-3sM=L3MQygyr9=sBkpSHcvk9ponxJTh2i=c=YiKA@mail.gmail.com>
	<4E3014E2.40501@suse.cz>
Date: Wed, 27 Jul 2011 11:11:16 -0400
Message-ID: <CACqU3MVyD8z=L8VP9K5c9iQaOPmWcqQprtM28VDzSVjwua_etQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] kconfig: Introduce KCONFIG(), KCONFIG_BUILTIN()
 and KCONFIG_MODULE()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kbuild@vger.kernel.org, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 27, 2011 at 9:38 AM, Michal Marek <mmarek@suse.cz> wrote:
>> [...]
>> I'm good with the naming, but how would you define those ? I may have
>> trouble to discern between IS_ENABLED() and IS_ENABLED_BUILTIN().
>
> IS_ENABLED() would mean not disabled, i.e. either 'y' or 'm'.
> IS_ENABLED_BUILTIN() would mean 'y' and only 'y' and IS_ENABLED_MODULE()
> would mean 'm'. For boolean options, IS_ENABLED() would be equivalent to
> IS_ENABLED_BUILTIN() and IS_ENABLED_MODULE() would be always false.
>
how would IS_ENABLED() behave on CONFIG_FOO, with FOO being S_STRING
or, say, S_HEX ?

 - Arnaud
