Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1DHKJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 06:09:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49740 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab1DHKJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 06:09:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vTthBx7Kpw+yYUhsmhDDg/TzbvQXX0yflxkAHG6qO3zbbvGl3v0JTizaT3pLLALapn
         POEe6dL0F53QWbo9ZVVs+JZnZEkrh+Z7M4IOlgmqDirfXSNocOTE1nEPNOWB0qSF60c/
         JEvYLFG4hczfH2USY+LQcKnkBloNCP2qD3V2E=
MIME-Version: 1.0
In-Reply-To: <4D9ED03C.2000706@snafu.de>
References: <Pine.LNX.4.44L0.1104051040440.1972-100000@iolanthe.rowland.org>
	<4D9C4262.1010704@snafu.de>
	<4D9ED03C.2000706@snafu.de>
Date: Fri, 8 Apr 2011 18:09:36 +0800
Message-ID: <BANLkTikmKCDTh8WAUNYtybZ=-Zj6GH1cAA@mail.gmail.com>
Subject: Re: [Libusb-devel] Kernel bug message and missing data on libusb_interrupt_transfer
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Oncaphillis <oncaphillis@snafu.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, libusb-devel@lists.sourceforge.net,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 5:07 PM, Oncaphillis <oncaphillis@snafu.de> wrote:
> Just a short update,
>
>  It doesn't seem to have anything to do with the libsub-1.0.x) version but
> with the --(enable|disable)-timerfd option of libusb configure. If libusb
> was configured with --disable-timerfd, which was the case for our 1.0.6 libusb
> I get the kernel bug message in in slub.c module and eventually a
> kernel freeze. This holds true for libusb-1.0.8 and kernel 2.6.38.2

What if you try libusb-stuge git tree? It has some fixes for the Linux side.

-- 
Xiaofan
