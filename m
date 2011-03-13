Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab1CMCQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 21:16:31 -0500
Received: from plecavalier.com ([64.40.149.83]:47968 "EHLO plecavalier.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab1CMCQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 21:16:28 -0500
Content-Type: text/plain; charset=UTF-8
Cc: =?utf-8?q?Alejandro_Riveira_Fern=C3=A1ndez?= <ariveira@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESOLVED] Re: Second drive on VT6421
From: Philippe LeCavalier <support@plecavalier.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
In-reply-to: <m3pqpw1226.fsf@intrepid.localdomain>
References: <1299350988-sup-2113@plc.intranet.plecavalier.com> <20110305210537.7675b600@varda> <1299355624-sup-9766@plc.intranet.plecavalier.com> <1299365533-sup-1295@plc.intranet.plecavalier.com> <m3pqpw1226.fsf@intrepid.localdomain>
Date: Sat, 12 Mar 2011 21:16:26 -0500
Message-Id: <1299982461-sup-9653@plc.intranet.plecavalier.com>
User-Agent: Sup/0.12.1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Krzysztof Halasa's message of Sat Mar 12 16:06:25 -0500 2011:
> Philippe LeCavalier <support@plecavalier.com> writes:
> 
> > There must be something about that chip...Perhaps the way the firmware
> > allocates the bandwidth. ie 2 channels with a total of 3Gbps then a
> > second drive cannot coexists if the first requests all 3Gbps?!
> 
> I think VT6421(A) is 1.5 Gb/s only.
> To be honest, It was never able to get it to work reliably, esp. with
> Transcend and/or Kingston SSDs.
I'm confident you're right. I just haven't come across any doc outlining
that. Since I resolved this, the drives have been running stable no
issues at all.
-- 
Thanks,
Phil
