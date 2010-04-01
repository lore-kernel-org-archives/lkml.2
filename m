Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0DAOwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 10:52:38 -0400
Received: from outgoing.selfhost.de ([82.98.87.70]:50241 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0DAOwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 10:52:32 -0400
Message-ID: <4BB4B32C.8080501@afaics.de>
Date: Thu, 01 Apr 2010 16:52:28 +0200
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Thunderbird/3.0.4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.1 regression: sound splutters
References: <4BB1E34B.5030207@darkharri.de>	<s5hhbnx1xen.wl%tiwai@suse.de>	<4BB467AD.7070001@afaics.de> <s5h1veza4vt.wl%tiwai@suse.de>
In-Reply-To: <s5h1veza4vt.wl%tiwai@suse.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/01/10 11:39, Takashi Iwai wrote:
> 
> OK, what about enable_msi=0 option for snd-hda-intel module?
> 

Now it works.

I have no idea what this enable_msi thing is about, but according
to Documentation/sound/alsa/ALSA-Configuration.txt it should be off
by default. Would you suggest to make this change permanent?


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAku0sywACgkQUTlbRTxpHjcevACfWThvjFATNwcA1q5vtz4LOVFz
JF8An3/+2d3OGmrJoEOJWEOY7n7If/GX
=sJ1q
-----END PGP SIGNATURE-----
