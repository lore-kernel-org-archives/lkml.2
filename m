Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0GZOnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:43:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60505 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab0GZOm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=D/ymV56IbfnEoA4VDmLiGtZ7jMdLxxvQUssqryNlKL0s6Ge7vKVmvARhXmh34yeihP
         3G4jGl/2P+Uta6BOHxrLMONRj9e72yq+k2lkXX3ab7h5v3E91QaiIr724FCqlcAzIjtE
         BaYjmY4FGKz2QylDC3Oe/52JccCw5Nv7ZoJLs=
Message-ID: <4C4D9EDA.3060505@gmail.com>
Date: Mon, 26 Jul 2010 16:42:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: alsa-devel@alsa-project.org
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        fengguang.wu@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: hda_intel: too quiet sound (regression)
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after I upgraded from 2.6.34-rc5-mm1 to 2.6.35-rc5-mm1 (there were other
issues in between them), the sound from my soundcard is very very quiet.

alsa-info:
http://www.alsa-project.org/db/?f=dcadb29a2d5d047ecf5545792ac3239dc0c8c7f0

Any ideas?

thanks,
-- 
js
