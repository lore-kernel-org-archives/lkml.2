Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0IYWUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 18:20:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41576 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab0IYWUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 18:20:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: Nigel's current for-rafael queue
Date: Sun, 26 Sep 2010 00:19:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
In-Reply-To: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009260019.37438.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 25, 2010, Nigel Cunningham wrote:
> Hi Rafael.

Hi Nigel,

> Please find attached a slightly updated version of the patchset I sent
> a few months ago. The main change is that I've prepended and additional
> patch which lets the user see the speed at which the image is being
> read and written. This is accomplished by recording the MB/s in a single
> byte in the image header, and using a couple of __nosavedata variables
> to get the data back through the atomic restore. I realise the char limits
> us to 255MB/s at the moment. In future patches, I intend to address this
> by storing the data in a 'proper' image header (it's a real problem -
> TuxOnIce reads and writes on the same set up at speeds around 250MB/s).
> 
> Results on my Dell XPS M1530, which has an SSD hard drive are:
> 
> With just patch 1 applied:
> Attempt 1: Write 74MB/s; Read 52MB/s
> Attempt 2: Write 68MB/s; Read 52MB/s
> Attempt 3: Write 73MB/s; Read 53MB/s
> 
> With the whole sequence:
> Attempt 1: Write 181MB/s; Read 52MB/s
> Attempt 2: Write 156MB/s; Read 53MB/s
> Attempt 3: Write 160MB/s; Read 52MB/s

Thanks for the patches, they look like a real improvement to me.

I only had a couple of minor comments, sent separately in replies to individual
patches.  I'd like to push this series for 2.6.37, if the comments are
addressed timely.

Best regards,
Rafael
