Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2LWWgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 17:36:12 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51558 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2LWWgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 17:36:10 -0500
MIME-Version: 1.0
In-Reply-To: <50D764BA.1030501@gmail.com>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
 <50D764BA.1030501@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Dec 2012 14:35:49 -0800
X-Google-Sender-Auth: sk8fdj8W8OD1FJv41ajaeMyUP4o
Message-ID: <CA+55aFwButY7LcOH2XCh1Q8fKi2KQiNS_Caj4O9cHzb4C=TKGw@mail.gmail.com>
Subject: Re: Linux 3.8-rc1 - another regression on USB :-(
To: Woody Suwalski <terraluna977@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Woody,
 Any chance you can bisect this? It's not going to be hugely pleasant
(with 11k+ commits in between 3.7 and 3.8-rc1 you'll have to compile
and test at least 14 kernels), but it would help enormously. Of
course, maybe some USB person can guess what would cause the device to
go offline..

Added Greg and the linux-usb mailing list to the participants list:
the images are in the original email on lkml, but there isn't anything
particularly interesting there, it really just seems to be an
unexpected and spurious USB disconnect, resulting in "USB disconnect,
device number 2" followed by "Rejecting I/O to offline device".

                  Linus

On Sun, Dec 23, 2012 at 12:08 PM, Woody Suwalski <terraluna977@gmail.com> wrote:
> I see a regression with USB subsystem when reading from a USB key.
> I have a live squashfs image, which suddenly has stopped working.
> It seems that USB prints this sequence:
>
> rejecting I/O to offline device
> killing request
> Unhandled error code
>
> I could not safe an actual dmesg - USB was dead...
> So I attach snapshots in place...
>
> The same squashfs seems OK with 3.7.1
> The same squashfs seems OK when run from ATAPIIX with 3.8-rc1
> So it looks like USB...
>
> Woody
>
