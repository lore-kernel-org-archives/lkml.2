Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0IUSs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:48:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60104 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0IUSs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:48:27 -0400
Date: Tue, 21 Sep 2010 20:48:20 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Heinz Diehl <htd@fritha.org>, Alan Ott <alan@signal11.us>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
Message-ID: <20100921184820.GA6379@fancy-poultry.org>
References: <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz>
 <20100812130411.GA1626@arch.tripp.de>
 <4C63F285.8070801@signal11.us>
 <20100812164035.GB6761@fritha.org>
 <20100920181100.GA12295@fancy-poultry.org>
 <alpine.LNX.2.00.1009211653510.26813@pobox.suse.cz>
 <20100921150900.GA6801@fritha.org>
 <alpine.LNX.2.00.1009211714400.26813@pobox.suse.cz>
 <20100921152728.GA13464@fritha.org>
 <alpine.LNX.2.00.1009211821560.26813@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1009211821560.26813@pobox.suse.cz>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100810 (GNU/Linux)
X-Provags-ID: V02:K0:3Wuc/Gd8rghCtkU4msjTHjO2kUhRypFVE51Q7N4wDdr
 nI6rVdfikZ1S7Y6DUjMvqH/vuoqXegwE55b5ra61ABiBAbvjEt
 fGwe7islf30gZgzzgGzU832ZuzIH14/vWxF8Qmd09F4KOsKfOV
 9Ko4V2vD+JlHfeaz8CK36oRcBUQL50AoVplFTumlcWWQnKv69u
 MSmy8l44EfG8BLCPzUSUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.09.2010, Jiri Kosina wrote: 

> Do you have 8fe294caf8c868edd9046251824a0af91991bf43 commit applied? (it 
> is included in -rc5).

That's it! All works fine now.
Many thanks for your patience and help!

Heinz
