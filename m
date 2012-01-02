Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2ABWUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 17:20:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51348 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2ABWT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 17:19:59 -0500
MIME-Version: 1.0
In-Reply-To: <20120102221235.GA16012@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
 <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
 <20120102211904.GA15316@srcf.ucam.org> <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
 <20120102215028.GA15701@srcf.ucam.org> <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
 <20120102221235.GA16012@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jan 2012 14:19:37 -0800
X-Google-Sender-Auth: QKzgDHsY_PYWDtCv2-pU9L6Dr7E
Message-ID: <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Matthew Garrett <mjg@redhat.com>
Cc: Jack Stone <jwjstone@fastmail.fm>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
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

On Mon, Jan 2, 2012 at 2:12 PM, Matthew Garrett <mjg@redhat.com> wrote:
>
> The kernel that loaded the firmware to make the device work is not
> required to be the same kernel that we're running when we suspend.

Why do you make up all these idiotic theoretical cases that nobody
cares about and has no relevance what-so-ever for the 99%?

Seriously? It's just stupid.

If you have some multi-kernel setup, or depend on booting windows
before booting Linux in order to have the firmware there, or you use
hibernate and switch things around (hibernate, not suspend - different
thing), and cannot load the firmware in the regular kernel, who the
hell cares?

And if you *can* load the firmware in the new kernel, just do it
before the suspend event. Problem solved.

And once more: your made-up scenario has *nothing* what-so-ever to do
with the actual warnings that started this whole thread.

You seem to *intentionally* be off in some random alternate reality
that is not relevant to anybody else, or to the actual reported
problems at hand.

Why?

                        Linus
