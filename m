Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab2DKWob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:44:31 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:45545 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2DKWoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:44:30 -0400
Message-ID: <4F86094C.1060700@hrz.tu-chemnitz.de>
Date: Thu, 12 Apr 2012 00:44:28 +0200
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 1/2] w1: Add 1-wire slave device driver for DS28E04-100
References: <4F63AF9E.2090000@hrz.tu-chemnitz.de> <20120409220847.GA13124@kroah.com>
In-Reply-To: <20120409220847.GA13124@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Scan-AV: nick.hrz.tu-chemnitz.de;2012-04-12 00:44:29;b2e4aa71d5cc986c83c065c2a1263934
X-Scan-SA: nick.hrz.tu-chemnitz.de;2012-04-12 00:44:29;042a857642c8090e5aca22f1db68377e
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.04.2012 00:08, schrieb Greg KH:

> On Fri, Mar 16, 2012 at 10:24:46PM +0100, Markus Franke wrote:
>> This patch adds a 1-wire slave device driver for the DS28E04-100.
>>
>> It applies to the current linux kernel git tree.
> 
> It's corrupted somehow and doesn't apply at all :(
> 
> Care to redo this one, and your 2/2 patch, against the 3.4-rc2 release
> and resend it, with Evgeniy's acks, so that I can apply it?  Please
> ensure that your email client doesn't mess it up again (hint, it is
> adding spaces at the front of the line of some parts of the diff.)


Used Thunderbird with external editor (vi) now, sent the patches to
myself and applied successfully. Hope it is in a shape which can be
accepted now.

Best regards,
Markus
