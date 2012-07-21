Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab2GURr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 13:47:56 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50835 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab2GURry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 13:47:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
Date: Sat, 21 Jul 2012 19:53:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-usb" <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com> <CA+55aFwZRvtpE2e3zNqvtobpPROqw_bOwNt+=DBzmScV0_rq=w@mail.gmail.com>
In-Reply-To: <CA+55aFwZRvtpE2e3zNqvtobpPROqw_bOwNt+=DBzmScV0_rq=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207211953.35791.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 21, 2012, Linus Torvalds wrote:
> On Fri, Jul 20, 2012 at 5:33 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> > The RFC patch is just for discussing if the idea of deferring
> > request_firmware is doable for addressing the issue of
> > request_firmware in resume path, which is caused by driver
> > unbind/rebind during resume.
> 
> NAK.

[...]

> Seriously. People should load their firmware *before* the
> suspend/resume cycle. And if that isn't possible, then the system
> should ABSOLUTELY NOT silently say "whatever" and defer it until
> later.  We should have that big failure and the big noisy warning, and
> drivers that need to defer need to do so themselves, so that we never
> *ever* have that silent automatic defer situation.

Well, thanks.  I totally agree, but didn't know how to say this. :-)

Rafael
