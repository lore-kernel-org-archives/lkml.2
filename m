Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2EBUhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:37:34 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:51310 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab2EBUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:37:30 -0400
X-Greylist: delayed 1475 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 16:37:30 EDT
Message-ID: <4FA1953B.40008@hrz.tu-chemnitz.de>
Date: Wed, 02 May 2012 22:12:43 +0200
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
References: <20120430021300.GA18148@kroah.com>
In-Reply-To: <20120430021300.GA18148@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Scan-AV: mailbox.hrz.tu-chemnitz.de;2012-05-02 22:12:45;bb4953f89a59eee71a5786af53a59e51
X-Scan-SA: cora.hrz.tu-chemnitz.de;2012-05-02 22:12:49;8c04717c9e42f237d02cc4ebafcd61a8
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -0.0 T_RP_MATCHES_RCVD Envelope sender domain matches handover relay
 *      domain
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

Am 30.04.2012 04:13, schrieb Greg KH:
> On Thu, Apr 12, 2012 at 12:40:30AM +0200, Markus Franke wrote:
>> This patch adds a 1-wire slave device driver for the DS28E04-100.
>>
>> Signed-off-by: Markus Franke<franm@hrz.tu-chemnitz.de>
>> Acked-by: Evgeniy Polyakov<zbr@ioremap.net>
>
> You have a lot of checkpatch warnings and errors, and you are creating

Don't have a clue what you mean. You were able to apply the patch 
successfully in the past.

> new sysfs files with no documentation at all as to what you are doing,
> and why you are doing it.  sysfs binary files at that, which should not
> be used by ANY code that is trying to intrepret the data being sent to
> those files, sysfs binary files are for "pass-through" mode only.

Well, I just stuck to the way things are done in already existing 
drivers e.g. drivers/w1/slaves/w1_ds2433.c

@Evgeniy: Any comments on this?

Best regards,

Markus Franke

