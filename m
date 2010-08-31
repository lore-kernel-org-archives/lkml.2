Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0HaLyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:54:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0HaLyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:54:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Tue, 31 Aug 2010 13:54:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        "Michael H. Warfield" <mhw@wittsend.com>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <201008311126.45190.arnd@arndb.de> <20100831104205.GA2301@bitwizard.nl>
In-Reply-To: <20100831104205.GA2301@bitwizard.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008311354.47275.arnd@arndb.de>
X-Provags-ID: V02:K0:/8IWChmJFPtkalotC55MGwAJoGp2ea6pRNfQFkt13XH
 3zCNlDB5JO73vgYMd6bwrvLgl0YMC7UcvMeU7lDmSWqsDiD1Ao
 nLD6eGRvd2wlCvHrUG1aR7tWp29Z0FSjcE4LweyNzBwO8tMepA
 YdLV+rxz65yM7Xj7Xq+RtGVQ77LHKV4nN2B231U8HHWh3pdu9c
 1UWmvkvMWinUJ0z8bLGHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 August 2010, Rogier Wolff wrote:
> The question is whether I want the drivers I wrote to stay or to
> go away?

More or less, yes.
 
> I was paid years ago to make Linux support the Specialix cards. It
> started with one card from their line of "solutions", but the others
> followed.

The most important question is whether you think that there are people
somewhere in the world that are using the device drivers on machines
with recent kernels.

If you still get bug reports for the drivers, that would be a clear
indication to make them stay, while if you haven't heard from a user
during the last five years, it's probably obsolete enough that it
can be removed (after a few kernels of grace period in drivers/staging).

	Arnd
