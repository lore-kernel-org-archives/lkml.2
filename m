Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927Ab0HLQko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:40:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55168 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0HLQkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:40:42 -0400
Date: Thu, 12 Aug 2010 18:40:35 +0200
From: Heinz Diehl <htd@fritha.org>
To: Alan Ott <alan@signal11.us>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
Message-ID: <20100812164035.GB6761@fritha.org>
References: <alpine.LNX.2.00.1008121108540.2702@pobox.suse.cz>
 <20100812091659.GA1591@arch.tripp.de>
 <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz>
 <20100812113624.GB1591@arch.tripp.de>
 <20100812114513.GA1584@arch.tripp.de>
 <20100812115657.GA1611@arch.tripp.de>
 <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz>
 <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz>
 <20100812130411.GA1626@arch.tripp.de>
 <4C63F285.8070801@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C63F285.8070801@signal11.us>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100810 (GNU/Linux)
X-Provags-ID: V02:K0:/ipQhZVBoaJWHHGSBxPlOlJ+KjDqSX+n1PV9QZDiI6B
 /P2EoJc7eoK2YgrAzQRu16HcZ+kOpgPoLZu8UaD6/8wKJkA21b
 +bzuqYXWpauNN/qHSwRCeWlRaYPP0cRzrLEClF4sBfMpvW3VI2
 zJs65IVIJP+en/N1ciVd608SFFHGdmosagJP2tuBVC4yDFRaJS
 GD9daUl4oVqMxZK5v5ZHQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.08.2010, Alan Ott wrote: 

> >>Could please those of you, who are able to reproduce the problem, verify
> >>whether the patch below (completely untested) makes everything behave
> >>again? Thanks.

> >Yes, everything behaves again. Thanks Jiri.
 
> Seconded. Works good. Thanks for your support Jiri.

Thirded! This fixes the warning here.

Thanks,
Heinz.
