Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1JXMfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:35:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47499 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab1JXMfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:35:43 -0400
Date: Mon, 24 Oct 2011 13:35:39 +0100
From: Andrew Benton <b3nton@gmail.com>
To: Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [drm:radeon_dp_i2c_aux_ch] *ERROR* aux i2c too many retries, giving
 up
Message-Id: <20111024133539.a910e1ea.b3nton@gmail.com>
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

When I boot up my computer with a 3.1 kernel I get a scary error
message just bellow the penguins:

[drm:radeon_dp_i2c_aux_ch] *ERROR* aux i2c too many retries, giving up

On a dual core it's printed twice, on a quad core it's printed 4 times.
I compile my kernels without modules and with the Radeon firmware
compiled into the kernel. As far as I can see the computers are working
perfectly but I'd like to understand this error message. It seems a bit
strange that it's printed to the screen even if I boot the kernel with
the quiet command line option. If someone could tell me what the error
message means I would be grateful (please CC me as I'm not subscribed).

I emailed this list asking about this last Wednesday but got no replies
so I've had to simply fall back on removing this kernel "feature":

sed -i 's#\tDRM_ERROR("aux i2c#//&#' \
  drivers/gpu/drm/radeon/atombios_dp.c

This makes the error message go away but it's not ideal, I'd rather
understand what it means.

Andy
