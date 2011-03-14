Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab1CNWn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:43:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42580 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751715Ab1CNWn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:43:28 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18Bv15OEJ8BI8wwuT8iB1OeBBtEC1TdU0wOtvHJ4w
	guS49gBL+4XxGV
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] staging/trivial: Fix common spelling mistakes
Date: Mon, 14 Mar 2011 23:43:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1103141259500.19969@pobox.suse.cz> <1300139875-8688-1-git-send-email-peterhuewe@gmx.de> <20110314220313.GA21204@kroah.com>
In-Reply-To: <20110314220313.GA21204@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103142343.23504.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 14 März 2011, 23:03:13 schrieb Greg KH:
> On Mon, Mar 14, 2011 at 10:57:55PM +0100, Peter Huewe wrote:
> > This patch fixes some very common spelling mistakes in drivers/staging
> 
> Unfortunatly, I've applied a bunch of patches since the last linux-next
> tree.
> 
> It would be nice if I could have taken a bunch of these changes, and if
> it was broken up into individual patches (each either doing only one
> spelling change, or only operating on one driver/file) then I could
> have.  But as it is, I can't :(
> 
> So, another reason it makes sense to break patches up into the logical
> pieces.  Please do this and resend.

Absolutely no problem, Greg. 
I thought since it is only a simple spellcheck in comments one big spellcheck 
patch would be logical enough.

I could split up by driver/directory with reasonable effort - would this be 
okay with you? Or do you want per file?
Or do you prefer the changes split by each spelling change?

I can recreate the patch(es) however you like them - so just tell me your 
preference.

Where can I find you current tree so I can patch against this one?

Thanks,
Peter

(p.s.:sorry for not hitting reply to all)

