Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab0LICmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 21:42:07 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:64732 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab0LICmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 21:42:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VmTlROpoBRbaLKvX7B7fZux+lLtN/RW70Z7ZKd3sWMd/pL1dUvKY+98qZQcAJpA5kQ
         GT0pAVPYhT/Nh+qGtXUXJvJehxkiOLyF2JZG606L4H4+Bb2X6L7rddiBwaPCk/mYz+tI
         g0/fXC02Rs9ZFh+WkpC8eREmoADxt8VKcvv10=
Subject: MEMSTICK: Add my 2 drivers
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alex Dubov <oakad@yahoo.com>, Andrew Morton <akpm@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 04:39:23 +0200
Message-ID: <1291862363.7792.28.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is standalone version of two drivers that I wrote for memstick
subsystem.

Due to attitude of Alex, I decided to avoid contributing to memstick
subsystem anymore unless I run into another unsupported chip, or
something like that, or any bugs in my code will be found.
Of course I will do my best to fix such bugs as fast as possible.
And I really care to have as little as possible bugs in my code.


Anderew Morton, older version of these drivers were in your tree for 2
cycles now, could you please set them for 2.6.38 inclusion?

Since I don't touch (and don't want anymore to) any code written by
Alex, and I even added workarounds for bugs in his jmicron driver to the
generic ms_block.c code (it tested and works on my both card readers),
maybe even add these to 2.6.37?

And as a  last comment about flamewar with Alex, which I don't want to
repeat, I think he ought to add himself as a maintainer of memstick code
he wrote, because it seems absurd that he refuses my contributions and
yet nether maintains it (code has few bugs that are result of bitrot, I
even have a merged commit for biggest one) nor he even appears in
MAINTAINERS for mspro_blk.c and memstick.c.

Sorry for my attitude, but its frustrating to see a month's work aimed
to make the code readable to be lost.

Best regards,
	Maxim Levitsky

