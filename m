Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153Ab2FHQkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:40:13 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:39154 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FHQkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:40:10 -0400
Date: Fri, 8 Jun 2012 18:40:04 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, zonque@gmail.com, tiwai@suse.de
Subject: [Bisected] ALSA: snd-usb: New streaming logic causes distortions on
 Burr-Brown DAC
Message-ID: <20120608164004.GA580@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hear distortions on my Burr-Brown USB DAC whenever the (software)
volume is set to some value lower than 100% in mpd. The lower the volume
the bigger are the resulting distortions.

I've bisected this to the two commits below:
(One wouldn't compile without the other)

commit d399ff9593e088d33fb38f5206c6427825892baa
Author: Daniel Mack <zonque@gmail.com>
Date:   Thu Apr 12 13:51:13 2012 +0200

    ALSA: snd-usb: remove old streaming logic

commit edcd3633e72a1590c4cf46befe5e6cd03b5aec3e
Author: Daniel Mack <zonque@gmail.com>
Date:   Thu Apr 12 13:51:12 2012 +0200

    ALSA: snd-usb: switch over to new endpoint streaming logic

-- 
Markus
