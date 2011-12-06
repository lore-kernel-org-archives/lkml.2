Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1LFT7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:59:41 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43892 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752735Ab1LFT7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:59:40 -0500
Message-ID: <4EDE820E.5040006@xenotime.net>
Date: Tue, 06 Dec 2011 12:58:54 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Martyn Welch <martyn.welch@ge.com>
Subject: Re: linux-next: Tree for Dec 6 (staging/vme)
References: <20111206154450.5e2ef2baed27993b23a55802@canb.auug.org.au>
In-Reply-To: <20111206154450.5e2ef2baed27993b23a55802@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 08:44 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20111205:


When CONFIG_GPIOLIB is not enabled:

drivers/staging/vme/devices/vme_pio2.h:237:19: error: field 'gc' has incomplete type

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
