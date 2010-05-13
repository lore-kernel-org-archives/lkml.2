Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0EMHFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:05:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58745 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0EMHFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:05:38 -0400
Date: Thu, 13 May 2010 09:05:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: system locks up when CD burn fails
Message-ID: <20100513070531.GA8491@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, david@lang.hm,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <alpine.DEB.2.01.1005121530090.8603@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1005121530090.8603@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: david@lang.hm
Date: Wed, May 12, 2010 at 03:35:06PM -0700

> I have a couple hundred boxes running kernels from 2.6.12 through
> 2.6.33.3 that each burn a backup to a IDE CD-ROM once a week. Every
> couple of months one of the boxes (_not_ the same one each time)
> runs into some sort of error when burning the CD and the entire box
> locks up (unable to toggle numlock even). I have not been able to
> find any correlation between failures and anything on the system.
> 
> when the system locks up it doesn't log anything, and the screen
> just freezes in the middle of the cdrecord status (X of Y MB
> written) with no error message.
> 
> I'm actually not worried that much about the burn failing, The
> problem is that the burn failing will take out the entire system. Is
> there anything that I should be doing to make the systems more
> robust in the face of such failures?

Are you using the ide drivers or libata? If it is the first, try
switching to libata to see whether this fixes your freezes.

-- 
Regards/Gruss,
    Boris.
