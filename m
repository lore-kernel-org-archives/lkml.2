Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025Ab2ABFfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 00:35:31 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46813 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2ABFf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 00:35:29 -0500
MIME-Version: 1.0
In-Reply-To: <201201020517.19624.marek.vasut@gmail.com>
References: <201201011322.34483.oliver@neukum.org> <Pine.LNX.4.44L0.1201011105200.4534-100000@netrider.rowland.org>
 <CA+55aFw-ar6dnPvn5wy=3Tv8fc_7Witri2mV=cCvH+aMv+jH1Q@mail.gmail.com> <201201020517.19624.marek.vasut@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 2 Jan 2012 06:35:06 +0100
Message-ID: <CA+XFjiqbU=WF+Ee7YdzQRZr4YZ00xhiMcOYawkQ9pX7DuYjbeQ@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 2, 2012 at 5:17 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
>
> FYI this is not only problem with USB, but with PCMCIA too for example.
>
> M

Also, PCI Express. Some Nvidia graphics cards only assume their real
PCI device ID during video POST (which can happen either as part of
system POST, if the card is primary, or during Linux startup/resume,
for a secondary card).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
