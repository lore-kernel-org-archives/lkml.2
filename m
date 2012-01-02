Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab2ABIiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:38:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64707 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2ABIiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 03:38:10 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Mon, 2 Jan 2012 09:38:06 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <201201011322.34483.oliver@neukum.org> <201201020517.19624.marek.vasut@gmail.com> <CA+XFjiqbU=WF+Ee7YdzQRZr4YZ00xhiMcOYawkQ9pX7DuYjbeQ@mail.gmail.com>
In-Reply-To: <CA+XFjiqbU=WF+Ee7YdzQRZr4YZ00xhiMcOYawkQ9pX7DuYjbeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201020938.07149.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jan 2, 2012 at 5:17 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
> > FYI this is not only problem with USB, but with PCMCIA too for example.
> > 
> > M
> 
> Also, PCI Express. Some Nvidia graphics cards only assume their real
> PCI device ID during video POST (which can happen either as part of
> system POST, if the card is primary, or during Linux startup/resume,
> for a secondary card).

Now that's really screwed. Is that "nvidia/intel optimus" also affected by this 
? (that thing where you have two GPUs in one laptop).

M
