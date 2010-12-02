Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab0LBN72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 08:59:28 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:38461
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757470Ab0LBN70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 08:59:26 -0500
X-IronPort-AV: E=Sophos;i="4.59,288,1288566000"; 
   d="scan'208";a="81144956"
Date: Thu, 2 Dec 2010 14:59:23 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: James Simmons <jsimmons@infradead.org>
Cc: Microcai <microcai@fedoraproject.org>, Vojtech Pavlik <vojtech@suse.cz>,
        linuxconsole@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Kernel fbcon UNICODE font support
Message-ID: <20101202135923.GA11944@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	James Simmons <jsimmons@infradead.org>,
	Microcai <microcai@fedoraproject.org>,
	Vojtech Pavlik <vojtech@suse.cz>, linuxconsole@vger.kernel.org,
	linuxconsole-dev@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1290750825.2372.59.camel@cai.gentoo> <20101127125742.GD4865@const.famille.thibault.fr> <AANLkTikfS+c93skkUFNLVJNah0DsjAUPE2jFNAQCAnCg@mail.gmail.com> <20101128081528.GA20705@suse.cz> <1290932981.710.2.camel@cai.gentoo> <alpine.LFD.2.00.1012020137320.28091@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1012020137320.28091@casper.infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Simmons, le Thu 02 Dec 2010 13:50:28 +0000, a écrit :
> 	This is nice and neat for vgacon but it doesn't flow so nicely with 
> graphical consoles or text LCDs. What I like to see is the attribute 
> buffer be split from the vc_screenbuf. The bonus is in embbeded systems we 
> could arrange the code so we could have a light weight printk VT without 
> the extra junk of the VC. Do we really need a attribute buffer for printk?  
> I believe that would be the first step in the right direction.

That's exactly what I suggested privately to Microcai. Increasing the
number of supported glyphs should then becomes way simpler, and
double-width not so far.

Samuel
