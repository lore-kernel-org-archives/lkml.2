Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0HRUtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:49:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50923 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab0HRUtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:49:50 -0400
Message-ID: <4C6C46EE.5010006@oracle.com>
Date: Wed, 18 Aug 2010 13:47:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: sound build error in mainline (CONFIG_PROC_FS=n)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ERROR: "hdmi_eld_update_pcm_info" [sound/pci/hda/snd-hda-codec-nvhdmi.ko] undefined!
ERROR: "hdmi_eld_update_pcm_info" [sound/pci/hda/snd-hda-codec-intelhdmi.ko] undefined!

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
