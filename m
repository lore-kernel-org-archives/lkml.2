Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab0KDKYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:24:08 -0400
Received: from mail-yx0-f194.google.com ([209.85.213.194]:50403 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0KDKYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=prfCdfxtHEg+ps8DrF5PoPPrFoDCdGlybVc4k/Zat+r/1Zw/cEZ2NVcrkuYYFIoePB
         Ac+R4WEUxf/YG77B51xZlWDOffFUXfH7w4HUVCis2L0FNzb0Ywkfi7hsr1dmRNJGzhz5
         ajMikKnVzyTYNPTi9Abtml//+03a3AC0gddOY=
MIME-Version: 1.0
In-Reply-To: <20101103140033.GA11915@isilmar-3.linta.de>
References: <AANLkTikbEgfVZmnVfbgGxbybbghXCuUgvEm03HH=i4HD@mail.gmail.com>
	<20101101160529.GA9306@comet.dominikbrodowski.net>
	<20101101220033.416.qmail@stuge.se>
	<AANLkTikBh3qAifA8U9--VyXZpD-vt3cuCj0M6npD4M3D@mail.gmail.com>
	<20101103140033.GA11915@isilmar-3.linta.de>
Date: Thu, 4 Nov 2010 18:08:50 +0800
Message-ID: <AANLkTinTPhk_jy6LHVVLieLEP7qJkgs-rD9eb=TobvM8@mail.gmail.com>
Subject: Re: PATCH : linux-2.6.35.4 drivers pcmcia cs.c
From: guillermo arias <papaguillee18@gmail.com>
To: guillermo arias <papaguillee18@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, linux-pcmcia@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for your time effort and dedication to us .

To Dominic Brodowski :.
> "if (!((True or False) || True))" => "if (!((True))" => "if False" .
It is an logical true , but if no_error=0 and error=1 the result of :.
# echo "$(( ! $(( 0 || 0 )) ))"
# 1 # not bypased from the main secuence .

To Peter Stuge .
> VPN?
correction :  "was probed with vnc ."
> Also .
> > >> 2) What's the output of "lspci -n -v"
> > >> 3) What's the output of "sudo lspcmcia -vvv"
in this little "Quick Replay" window if an huge text is inserted , i
can't control it .
> > >> 4) Are there any BIOS options you may toggle to enable CardBus? .
no .

sorry gentlemans but i try to do my best .
//gar ; from Venezuela in an 56Kbauds pot https connection .
