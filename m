Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1BVIqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:46:10 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:35300 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1BVIqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:46:09 -0500
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1298356917-486-1-git-send-email-hayeswang@realtek.com> <1298356917-486-3-git-send-email-hayeswang@realtek.com> <20110222080017.GA12453@electric-eye.fr.zoreil.com> <20110222082153.GA12463@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH 3/5] r8169: fix the wrong parameter of point address
Date: Tue, 22 Feb 2011 16:46:02 +0800
X-BOX-Message-Id: p1M8k3hi023431
Message-ID: <F0C0A9D890424ECAAB19523FCC4A2FCC@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcvSahLlPoQQ920GQnGRCeH1mv+cQwAAcfYg
In-Reply-To: <20110222082153.GA12463@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Tuesday, February 22, 2011 4:22 PM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 3/5] r8169: fix the wrong parameter of 
> point address
> 
> Francois Romieu <romieu@fr.zoreil.com> :
> > Hayes Wang <hayeswang@realtek.com> :
> > > Correct the parameter of rtl8168_oob_notify. It results 
> in the wrong 
> > > point address and influences RTL8168DP.
> > 
> > Please send this one separately as a patch against current 
> kernel tree 
> > as it is clearly a bugfix. The remaining patches are probably more 
> > -next material.
> 
> Correct me if I am wrong:
> - #3 and #1 are bugfixes
> - can you specify if #4 and #5 are either bugfixes, 
> optimizations or cleanups ?
> - #2 adds support for a new chipset

#1, #3, #4 are bugfixes.
#2 adds support for a new chipset
#5 is cleanup.

I would separate them and send the patches again.

 
Best Regards,
Hayes

