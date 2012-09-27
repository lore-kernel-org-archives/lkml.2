Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2I0WBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:01:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50417 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab2I0WBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:01:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120927210335.GA3468@kroah.com>
References: <5017A064.1030605@unicontrols.cz>
	<5018AFA8.8070709@lougher.demon.co.uk>
	<CAMuHMdXXP=iF8qiBydYGgaKUpTR=88Y7uUTf9uquA7cbwMeo7w@mail.gmail.com>
	<20120927210335.GA3468@kroah.com>
Date: Thu, 27 Sep 2012 23:01:15 +0100
Message-ID: <CAB3wodcNjH9BQD54YL4tamRkzdkvPdBMo+ZM6xnLB8n8vrUZdg@mail.gmail.com>
Subject: Re: [Squashfs-devel] PROBLEM: mount empty SquashFS
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Cyril Strejc <strejc@unicontrols.cz>, phillip@squashfs.org.uk,
        squashfs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:03 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Sep 04, 2012 at 08:52:44PM +0200, Geert Uytterhoeven wrote:
>>
>> So I think this warrants application to the stable 3.0, 3.1, and 3.2 branches.
>> Commit cc37f75a9ffbbfcb1c3297534f293c8284e3c5a6 ("Squashfs: fix
>> mount time sanity check for corrupted superblock") seems to cherry-pick just
>> fine on v3.0.42, v3.1.10, and v3.2.28.
>
> Queued up for 3.0.y, thanks.
>

Thanks Greg

Phillip
