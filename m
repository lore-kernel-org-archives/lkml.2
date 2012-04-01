Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2DAQ7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:59:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35108 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2DAQ7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:59:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120401161108.GA6448@milliways>
References: <20120316233829.GA14022@kroah.com> <20120316233811.136320350@linuxfoundation.org>
 <20120331032356.GA6664@milliways> <20120401161108.GA6448@milliways>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Apr 2012 09:59:12 -0700
X-Google-Sender-Auth: j_i54yTbU0WZe8Jd5NYnK0Ipf0E
Message-ID: <CA+55aFzEgpfBvFmxQnvaD0RY5q2ST1G_ue=u0Gpbxeptc4+TNA@mail.gmail.com>
Subject: Re: [ 06/41] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 9:11 AM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
>
>  BUT, for 3.4.0-rc1 I don't need to revert it - just went with the
> defaults for additions in menuconfig, and it boots fine.  Maybe
> something else needs to be backported ?

It was fixed by commit c9651e70ad0a ("ASPM: Fix pcie devices with
non-pcie children") which is marked for stable but just hasn't made it
quite yet.

                   Linus
