Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab0IGUPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:15:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab0IGUPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:15:30 -0400
Message-ID: <4C869D2E.5060505@vlnb.net>
Date: Wed, 08 Sep 2010 00:14:38 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org,
        Chetan Loke <chetanloke@gmail.com>,
        Chetan Loke <generationgnu@yahoo.com>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
References: <1283204792.32007.448.camel@haakon2.linux-iscsi.org> <4C7FFD1A.8090509@vlnb.net> <1283459158.5598.143.camel@haakon2.linux-iscsi.org> <20100905201802.GC18411@core.coreip.homeip.net> <1283723447.556.133.camel@haakon2.linux-iscsi.org> <20100905234134.GA17212@core.coreip.homeip.net> <1283731194.556.147.camel@haakon2.linux-iscsi.org> <1283769578.15944.1293.camel@mulgrave.site> <4C85617E.2080603@vlnb.net> <1283810135.556.238.camel@haakon2.linux-iscsi.org> <20100907004424.GB21430@core.coreip.homeip.net>
In-Reply-To: <20100907004424.GB21430@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:KXTkF0nic36fa5mOR0IYFflj/cwe0vGLT80c2JAxJvj
 CSYUpVVxw1yJ3+lhtPP6iNdFkurLSh5lKnlzXyuXoqShCXNUxo
 XTlXgLFGqPRjB5mpbVzXyZ5gQeBzxKvYucFHRqp2PtgiLHbbhk
 SMaZO39shB4wNNBj5REc4ncacG+vLLAAquuVQBFplpHJBa75Dy
 GXB4LP9kkBxdIx2b5y0fA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov, on 09/07/2010 04:44 AM wrote:
>> So at this point, I will once again to refrain from any non technical
>> interaction with yourself.  If you have geninue concerns about any of
>> the TCM/LIO v4 code, then I suggest that you and your devels make them
>> known from within threads containing [PATCH] and [RFC] tags, because I
>> will not be bothering with anything that does not contain comments on
>> creating new or improving existing design and code.
>>
>
> I think this is somewhat backwards...
>
> Vlad appears to be asserting that SCST is more feature-complete that LIO
> at this point. It also seems that LIO is somewhat younger than SCST. So
> at this point it might be interesting to see:
>
> 1. What are the shortcomings of SCST design compared to LIO and why LIO
> developers chose to come with their own solution instead of
> collaborating with SCST folks?
>
> 2. What features are missing from SCST that are currently available in
> LIO?
>
> Once this is sorted out and [most] everyone agrees that LIO is indeed
> technically superior (even if maybe not as mature yet) solution, then it
> would make sense to request SCST developers to go to file/line depth of
> the review.

Those are exactly the questions trying to hear answers on which I'm 
hitting the wall in past time.

Thanks!
Vlad
