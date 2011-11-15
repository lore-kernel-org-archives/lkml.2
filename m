Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab1KON7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 08:59:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54063 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab1KON7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 08:59:43 -0500
Date: Tue, 15 Nov 2011 14:59:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlA==?= =?utf-8?B?5aSNOg==?=
 3.1-rc6+ rtl8192se issue
Message-ID: <20111115135938.GD3292@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org,
	'LKML' <linux-kernel@vger.kernel.org>
References: <791179BCE62F4954AB936E6CAC9CA977@realsil.com.cn>
 <4E7AAB8B.40900@lwfinger.net>
 <20110922075115.GA17640@liondog.tnic>
 <6452E68488784D0EA32E4BDF1B941EFB@realsil.com.cn>
 <20110923103339.GA26078@gere.osrc.amd.com>
 <4E7CB504.4060904@lwfinger.net>
 <20110928131823.GA2693@gere.osrc.amd.com>
 <4E83D092.7010405@lwfinger.net>
 <20111005151533.GA18592@gere.osrc.amd.com>
 <4E8D1465.207@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E8D1465.207@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 09:37:25PM -0500, Larry Finger wrote:
> I have been going though the differences between the 06/20/2011 and
> 08/16/2011 drivers and making those changes to the kernel drivers.
> Could you please apply the 5 attached patches to the
> wireless-testing tree and see if your sluggishness is fixed?

Just to document it here:

3.1 still has the problem, if you have something ready ported to 3.1
from the Realsil driver version, let me know and I'll give it a run.

Thanks.

-- 
Regards/Gruss,
   Boris
