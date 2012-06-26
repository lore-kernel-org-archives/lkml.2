Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab2FZONr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:13:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51956 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2FZONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:13:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: alsa-devel@alsa-project.org
Cc: lkml <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: [Regression] No sound on HP Pavilion dv6, STAC92xx
Date: Tue, 26 Jun 2012 15:13:43 +0100
Message-ID: <87d34mtb3c.fsf@canonical.com>
User-Agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After commit b0791dda813c179e539b0fc1ecd3f5f30f2571e2 ("ALSA: hda/idt
- Fix power-map for speaker-pins with some HP laptops") we have
several bug reports about not having sound on HP Pavilion laptops.

Here's a link to one of these bug reports:

 http://bugs.launchpad.net/bugs/1013183

After reverting the referred commit, everything seems to be working
fine again.

Any ideas/fixes?

Cheers,
--
Luis
