Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2ACHjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:39:51 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:58235 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2ACHju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:39:50 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Jack Stone <jwjstone@fastmail.fm>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Tue, 3 Jan 2012 08:41:32 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Marek Vasut <marek.vasut@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthew Garrett <mjg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <201201030131.15397.marek.vasut@gmail.com> <c163595a-163e-4e68-ba0f-de5ca58e8de9@email.android.com>
In-Reply-To: <c163595a-163e-4e68-ba0f-de5ca58e8de9@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201030841.32402.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Januar 2012, 01:44:07 schrieb Jack Stone:
> >> Its a perfectly good idea but you still need the full memory
> >requirement
> >> during the suspend.
> >
> >Hm ... and we can't have memory type that "can be swapped-out, but must
> >be 
> >loaded back before suspend" in kernel, right?
> 
> Nope. Kernel swapping is a big headache and Linux doesn't do it. The only thing we can do is drop any clean cache pages, but that has performance implications.

There is however a notifier chain that is called early enough
to still load stuff from disk so that the additional burden on memory
would be used only when it might be needed.

	Regards
		Oliver
