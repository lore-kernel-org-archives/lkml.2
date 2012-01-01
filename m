Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2AAJqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 04:46:42 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:46302 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2AAJqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 04:46:40 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Marek Vasut <marek.vasut@gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Sun, 1 Jan 2012 10:48:18 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Matthew Garrett <mjg@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <20111230235421.GA6054@redhat.com> <CA+55aFyqm4FbW=--7U4ULk1EBb6RLP0sRgtokODBYnZNiJXWew@mail.gmail.com> <201112311939.19170.marek.vasut@gmail.com>
In-Reply-To: <201112311939.19170.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201011048.18953.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 31. Dezember 2011, 19:39:18 schrieb Marek Vasut:

> maybe we should implement such thing into the firmware loader itself? Allow it 
> -- for example via some node in /dev -- to force loading firmware into some 
> buffer in kernel just before suspend so it'll certainly be readily available at 
> resume time?

This is difficult. We don't know at suspend time which firmware we will
need at resume time. We could keep a record of firmware we needed
to get to the state we are, but this is a very complex scheme.

	Regards
		Oliver
