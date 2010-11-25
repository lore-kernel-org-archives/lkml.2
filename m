Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab0KYACK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 19:02:10 -0500
Received: from ozlabs.org ([203.10.76.45]:52554 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0KYACG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 19:02:06 -0500
Date: Thu, 25 Nov 2010 11:02:04 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Rabin Vincent <rabin@rab.in>,
        =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Cross compilers available on kernel.org
Message-ID: <20101125000204.GI19615@ozlabs.org>
Mail-Followup-To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
	Mikael Pettersson <mikpe@it.uu.se>, Rabin Vincent <rabin@rab.in>,
	=?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
	linux-arm-kernel@lists.infradead.org
References: <1288897002-24073-1-git-send-email-rabin@rab.in>
 <yw1xy698ygbx.fsf@unicorn.mansr.com>
 <19667.9199.798932.405415@pilspetsen.it.uu.se>
 <AANLkTinUcS3v57bMLXcHaqC+OGoAqgoK2td-ce3B6FOM@mail.gmail.com>
 <19667.52998.909668.596635@pilspetsen.it.uu.se>
 <AANLkTimkSxWNL+aCALGsf5prBM_RHz0BMHCeNwKrTnfA@mail.gmail.com>
 <19668.21026.5416.610777@pilspetsen.it.uu.se>
 <20101112044548.GA19615@ozlabs.org>
 <19676.63422.614246.989202@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19676.63422.614246.989202@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All, 
        I've just added 4.4.5 and 4.5.1 hosted on i686 and x86_64 to:
http://kernel.org/pub/tools/crosstool/files/bin/

These compilers do not have libc support so they're pretty much only useful
for building the kernel.

If you'd like to see other platforms there or have feature requests don't
hesitate to poke me.

Yours Tony
