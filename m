Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1JSS3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:29:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48326 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1JSS27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:28:59 -0400
Date: Wed, 19 Oct 2011 19:28:55 +0100
From: Andrew Benton <b3nton@gmail.com>
To: Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [drm:radeon_dp_i2c_aux_ch] *ERROR* aux i2c too many retries, giving
 up
Message-Id: <20111019192855.73e45b54.b3nton@gmail.com>
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please cc me in any replies as I'm not subscribed.

When booting a 3.1.0-rc10 kernel, right at the start I get an error
message printed to the screen:

[drm:radeon_dp_i2c_aux_ch] *ERROR* aux i2c too many retries, giving up

It's a quad core computer and it prints it 4 times. On another computer
which is a dual core it prints the message twice. Both computers have
Radeon graphics cards which need firmware compiled into the kernel to
work. This computer uses BARTS_mc.bin, BARTS_me.bin, BARTS_pfp.bin and
BTC_rlc.bin. The kitchen computer uses REDWOOD_rlc.bin, REDWOOD_pfp.bin
and REDWOOD_me.bin. Both computers seem to be working fine as far as I
can see. Is this error message something to be concerned about? I
thought the radeon driver uses i2c to enable sensors to report the
temperature of the card, but that seems to be working fine. I boot with
the quite command line argument and it gets rid of most kernel output,
but not these error messages. Is there some way I can get rid of these
alarming messages? Some kernel option that will make them just complain
to the kernel log? Or is there some option I should enable to keep the
radeon i2c whatever it is happy?

Andy
