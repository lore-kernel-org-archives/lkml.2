Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0LVAh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:37:56 -0500
Received: from smtpout06.highway.telekom.at ([195.3.96.89]:30586 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752865Ab0LVAhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:37:55 -0500
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2] USB: add support for Dream Cheeky DL100B Webmail Notifier (1d34:0004)
Date: Wed, 22 Dec 2010 01:37:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2+; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201012220058.43366@rk-nord.at> <20101222001907.GA16255@kroah.com>
In-Reply-To: <20101222001907.GA16255@kroah.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012220137.51440@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH -- Wednesday 22 December 2010:
> On Wed, Dec 22, 2010 at 12:58:42AM +0100, Melchior FRANZ wrote:
> > - I increased the file's version number (1.1 -> 1.2). Hope that's OK.
> 
> Actually, you could just remove it, it's pretty pointless :)

Yeah, that's what I thought. But leaving it at 1.1 was even more pointless,
so I aimed for the most conservative solution.  :-)



> I would, but it looks like you didn't test this patch out by building it
> as the following line really would not compile properly at all, right:

> > +					0x200, The price difference to Delcom's thingy lets you a lot of room. :-)

Of course, I tested it. That garbage is not in the code, or in the generated
diff. This happened after importing the correct diff into kmail. Probably
and accidantal MMB click. Sigh. OK, it's my fault, no matter what ...



> Third times a charm?

Heh. Coming along ...
Thanks for reviewing.

m.
