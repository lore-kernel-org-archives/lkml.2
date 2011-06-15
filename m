Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1FOTVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:21:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60359 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab1FOTV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:21:27 -0400
MIME-Version: 1.0
In-Reply-To: <4DF8F2E5.4090705@oracle.com>
References: <4DDB3AFF.9030006@oracle.com> <20110524075248.GB19734@sirena.org.uk>
 <20110527074552.GA907@ponder.secretlab.ca> <4DDFE391.2030507@oracle.com>
 <20110527201201.GA6645@ponder.secretlab.ca> <BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
 <20110603171837.GA9918@opensource.wolfsonmicro.com> <BANLkTi=oko_C8_46Y8p5O1Qvw1KEn-1PjA@mail.gmail.com>
 <4DEC4D67.6010506@oracle.com> <20110614091211.465553de.randy.dunlap@oracle.com>
 <20110614161357.GB1839@ponder.secretlab.ca> <20110614170602.7a51b1af.randy.dunlap@oracle.com>
 <20110615103420.1578eb5c.sfr@canb.auug.org.au> <4DF8F2E5.4090705@oracle.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 15 Jun 2011 13:21:07 -0600
X-Google-Sender-Auth: zqa_psgK7agyxv5aLYBI3lf5YoI
Message-ID: <BANLkTikJ8v-hhvfApJm4Pz0w7-ttiTYADw@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: include linux/gpio.h where needed
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Dmitry Artamonow <mad_soft@inbox.ru>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Harald Welte <laforge@gnufiish.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 11:59 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 06/14/11 17:34, Stephen Rothwell wrote:
>> Hi Randy,
>>
>> On Tue, 14 Jun 2011 17:06:02 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> Some files use GPIOF_ macros but don't include the header file
>>> for them.  These macros are being moved to <linux/gpio.h>, so add
>>> includes for <linux/gpio.h> where needed.
>>
>> Shouldn't these patches be in the other order to avoid bisection problems?
>
> Hm, I suppose so.
>
> Grant, can you apply these with patch 2/2 first or do I need to resend
> the patches?

You don't need to resend.  I'll apply them in the correct order.

g.
