Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab2AEXIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:08:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35809 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2AEXIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:08:10 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Andrew Burgess'" <aab@cichlid.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-uvc-devel@lists.berlios.de>
References: <CAO9zADw7ofMLeE3yCQ+uCe=6EzZY=SWtqMDhsi_ggbPhWVfTKg@mail.gmail.com> (from jpiszcz@lucidpixels.com on Tue Jan  3 06:21:02 2012) <1325694071.16950.49@hogo> <003301cccb03$4a8cbea0$dfa63be0$@lucidpixels.com>
In-Reply-To: <003301cccb03$4a8cbea0$dfa63be0$@lucidpixels.com>
Subject: RE: 3.1.5: uvcvideo: Failed to resubmit video URB (-27).
Date: Thu, 5 Jan 2012 18:08:08 -0500
Message-ID: <017d01cccbfe$e3a82100$aaf86300$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEP3FQPGNkjbsETjYM87qM0UoHbNAGqYLYAAwAb7q+XUvD9UA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Andrew Burgess [mailto:aab@cichlid.com] 

it sounds like a bug recently tracked down on the usb devel list
(search for 'Failed to resubmit video URB')

it turned out to be a bug in the usb host controller; if you
do an lspci do you see anything made by NetMos or MosChip?

--

Hi,

Running kernel 3.2 for 12+ hours, no issues yet, will update thread if any further issues occur.

Justin.

