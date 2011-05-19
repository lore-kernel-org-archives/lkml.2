Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab1ESXWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:22:36 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:44784 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751998Ab1ESXWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:22:35 -0400
Date: Fri, 20 May 2011 00:22:21 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-mips@linux-mips.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Namhyung Kim <namhyung@gmail.com>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC] Remove Alchemy OSS drivers?
Message-ID: <20110519232221.GC10628@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OSS has very little if any useful life in it left for MIPS, at least from
my perspective.  So I propose to remove the Au1550 driver - there is an
ALSA replacement for it available.

Anybody against it?  Are there still any remaining features or platforms
that are only supported by the OSS driver?

The OSS code is so backwards that I'd like to retire the possible remaining
MIPS users and then make OSS unavailable in Kconfig for MIPS.

  Ralf
