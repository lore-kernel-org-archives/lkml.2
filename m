Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1EZBec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 21:34:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab1EZBeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 21:34:31 -0400
Date: Wed, 25 May 2011 21:34:24 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Subject: no sound in current -git
Message-ID: <20110526013423.GA25226@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Takashi Iwai <tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the last ALSA merge, I have no sound on my laptop.
I have onboard intel sound, and a NuForce µDAC. Neither of them show up
in alsamixer, or pavucontrol.

Is this a clue ?
 
 ALSA sound/usb/mixer.c:803: 3:0: cannot get min/max values for control 2 (id 3)

59bb7f0eebe69aa32a5c7917a23a7da1c5667d73 perhaps ?

	Dave

