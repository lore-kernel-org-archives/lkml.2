Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0HXRvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:51:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab0HXRvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:51:53 -0400
Message-ID: <4C7406AA.7080308@vlnb.net>
Date: Tue, 24 Aug 2010 21:51:38 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Pasi K?rkk?inen <pasik@iki.fi>, Chetan Loke <chetanloke@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        scst-devel <scst-devel@lists.sourceforge.net>
Subject: Re: Linux I/O subsystem performance
References: <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site> <AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com> <1282508953.3042.102.camel@mulgrave.site> <4C727BEB.9020100@scalableinformatics.com> <AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com> <AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com> <AANLkTim+fj-OL+Bixfbrxv6AgSVv_NpT-KdG6vrc6ub-@mail.gmail.com> <20100824072557.GK2804@reaktio.net> <4C73DA91.9040101@vlnb.net> <20100824145522.GQ12892@parisc-linux.org>
In-Reply-To: <20100824145522.GQ12892@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:Gzx4gXZpqZF90MpHs37PgxRLLouAoqHJgbQu55qNSKS
 6KVO7pJ7ZRwwz4qnhaks2vo7cLdlzZBTcYwb2rh0L6yDoyn3MT
 90yPREH3+slvhRej9jQb9QjsXroPLW8UZPLY282nxUBCn/XgXE
 rtolXrT2NeUQzDWIblRpgJ7hBOY+ujqA2ACEZkM0zZ5ZXwyase
 DU2wYxbRqLhVu4kMEj4Qg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox, on 08/24/2010 06:55 PM wrote:
> On Tue, Aug 24, 2010 at 06:43:29PM +0400, Vladislav Bolkhovitin wrote:
>> Also it looks very suspicious why nobody even tried to match that
>> Microsoft/Intel record, even Intel itself who closely works with Linux
>> community in the storage area and could do it using the same hardware.
>
> You seem to be under the impression that "Intel" is some monolithic
> entity.  Despite working with six different storage&  performance
> groups within Intel, I have no idea what record you're referring to,
> nor what hardware it was accomplished with.

It is 
http://communities.intel.com/community/wired/blog/2010/04/22/1-million-iops-how-about-125-million

> Even if I did, I wouldn't
> know which group within Intel to contact to see if they still have
> the setup.  Then I'd have to convince them that it's in their interest
> to try to replicate this on Linux.  And I'd have to be prepared to sink
> a considerable quantity of my time into it ... which I don't have.

Sorry if it looked like I was blaming you. I just was wondering why 
Intel developed Linux drivers for those network adapters and isn't 
interested to similarly demonstrate their performance on Linux.

Vlad
