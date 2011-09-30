Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab1I3Dvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:51:52 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:7545
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755936Ab1I3Dvv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:51:51 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz9371K542M1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LSBHE8-01-GSR-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Dave Airlie <airlied@redhat.com>
Date: Thu, 29 Sep 2011 22:51:43 -0500
Subject: RE: [134/244] drm/radeon/kms: fix typo in r100_blit_copy
Thread-Topic: [134/244] drm/radeon/kms: fix typo in r100_blit_copy
Thread-Index: Acx+2kFcSFgYWijGTYWe7raoAD0ywgASfgqA
Message-ID: <82951087A1ED9648A152812B736362500A8F29457F@sausexmbp02.amd.com>
References: <20110928220225.GA27128@kroah.com>
 <20110928220139.453112165@clark.kroah.org>
 <82951087A1ED9648A152812B736362500A8F294274@sausexmbp02.amd.com>
 <20110929185522.GA8183@suse.de>
In-Reply-To: <20110929185522.GA8183@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Thursday, September 29, 2011 2:55 PM
> To: Deucher, Alexander
> Cc: linux-kernel@vger.kernel.org; stable@kernel.org; stable-
> review@kernel.org; torvalds@linux-foundation.org; akpm@linux-
> foundation.org; alan@lxorguk.ukuu.org.uk; Dave Airlie
> Subject: Re: [134/244] drm/radeon/kms: fix typo in r100_blit_copy
> 
> On Wed, Sep 28, 2011 at 09:31:47PM -0500, Deucher, Alexander wrote:
> > Please don't apply this to stable.  The patch ended up being in error.
> 
> Was it also reverted upstream?

Yes.

Alex

> 
> I'll go drop it now, thanks.
> 
> greg k-h


