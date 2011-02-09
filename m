Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1BIHfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 02:35:08 -0500
Received: from compulab.co.il ([67.18.134.219]:57365 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab1BIHfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 02:35:06 -0500
Message-ID: <4D52439F.9090505@compulab.co.il>
Date: Wed, 09 Feb 2011 09:34:55 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Linux-Next <linux-next@vger.kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: drivers/input/touchscreen/ads7846.c:959: error: 'GPIOF_DIR_IN'
 undeclared
References: <AANLkTim2706Negrvd-ektbNMLwucM9M0icphb_uFY_9D@mail.gmail.com> <20110208211035.GC16527@core.coreip.homeip.net> <20110208212046.GA29410@pengutronix.de>
In-Reply-To: <20110208212046.GA29410@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/11 23:20, Wolfram Sang wrote:

> On Tue, Feb 08, 2011 at 01:10:36PM -0800, Dmitry Torokhov wrote:
>
>> Crap, sorry about that, I'll fix it up tonight.
> I had the same issue while working on some other gpio-cleanup.
> I am just about to finish a patch.

This was pretty obvious and I had a thought that this will happen,
but failed in sharing my thoughts with you back then.
May be because of too much talking around it... Sorry... :(

-- 
Regards,
Igor.

