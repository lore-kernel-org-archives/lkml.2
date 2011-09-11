Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350Ab1IKTGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 15:06:20 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35528 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760295Ab1IKTGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 15:06:19 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: graceful handling of removing a plugable storage device that is being written to
Date: Sun, 11 Sep 2011 21:06:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1315751507.52552.YahooMailClassic@web29517.mail.ird.yahoo.com> <201109111853.20530.Martin@lichtvoll.de> <CAMuHMdUC0bR+SF0oLHb3JYQLyg2y_imak5Ns7pksqvXVha8X6A@mail.gmail.com> (sfid-20110911_210415_171129_50324A7B)
In-Reply-To: <CAMuHMdUC0bR+SF0oLHb3JYQLyg2y_imak5Ns7pksqvXVha8X6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109112106.17705.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 11. September 2011 schrieb Geert Uytterhoeven:
> On Sun, Sep 11, 2011 at 18:53, Martin Steigerwald <Martin@lichtvoll.de> 
wrote:
> > Frankly, I never tried this on AmigaOS. I know that AmigaOS expects
> > the exact same floppy disk to be inserted again. Only the same name
> > isn´t enough. But I have no idea, what AmigaOS would have done, when
> > I inserted
> 
> Are you sure the volume name wasn't enough?
> For most things, it relied on the volume name, that's how you could map
> floppy names to hard drive directories using assigns.

Yes, I am pretty sure I tried that back then. Difficult to repeat at the 
moment, since I think at least the high density disk drive in my A4000 is 
toast since quite a while.

Anyway, if Linux implements something like that it should not only depend 
on a volume name ;).

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
