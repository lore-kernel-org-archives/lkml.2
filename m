Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab2EMNEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:04:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42179 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752921Ab2EMNET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:04:19 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18BYbs3JAIBGaVCx6bXt46FjHi/2KoaVTy1aiEovk
	gv8+6xJCCWG61n
Message-ID: <4FAFB14A.2020705@gmx.de>
Date: Sun, 13 May 2012 13:04:10 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
CC: Thomas Winischhofer <thomas@winischhofer.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video/sis: Annotate SiS_DRAMType as __devinitconst
References: <4FAB0986.6090006@gmx.de> <201205102339.09295.PeterHuewe@gmx.de>
In-Reply-To: <201205102339.09295.PeterHuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 05/10/2012 09:39 PM, Peter Hüwe wrote:
> Am Donnerstag 10 Mai 2012, 02:19:18 schrieb Florian Tobias Schandinat:
>> Good that you did this one, it was more to be done than I expected. I
>> ignored the checkpatch errors as you didn't introduce them but maybe it
>> wouldn't be a bad idea to fix things up if you touch them. Applied.
> 
> Oh sorry, usually I do checkpatch, but I missed it on this one somehow.
> If you want, I can do a checkpatch cleanup for the whole sis driver as 
> compensation ;)

That's not necessary.
I just wanted to highlight that I prefer it if people fix the style
on-the-fly while working on things rather than sending me individual
patches for each line and not even fixing the complete line but only one
special aspect of it so that checkpatch complains about their style fixes.

btw. Special characters are allowed in sign-offs.


Best regards,

Florian Tobias Schandinat
