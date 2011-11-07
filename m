Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab1KGRXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:23:24 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:57656 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754814Ab1KGRXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:23:22 -0500
Message-ID: <4EB813CB.8060508@xenotime.net>
Date: Mon, 07 Nov 2011 09:22:19 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
Subject: Re: linux-next: Tree for Nov 5(7) [x86/platform/ts5500_adc.c]
References: <20111107141319.b1d38ed603420631274515e6@canb.auug.org.au>
In-Reply-To: <20111107141319.b1d38ed603420631274515e6@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 07:13 PM, Stephen Rothwell wrote:
> Hi all,


When CONFIG_HWMON=m and CONFIG_TS5500_ADC=y (since it is bool):

ts5500_adc.c:(.devinit.text+0x322): undefined reference to `hwmon_device_register'

You could make CONFIG_TS5500_ADC depend on CONFIG_HWMON=y ...
or add loadable module support for ts5500 drivers/modules.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
