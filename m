Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1AFP5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:57:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54912 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1AFP5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:57:01 -0500
Date: Thu, 6 Jan 2011 16:56:41 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Heinz Diehl <htd@fritha.org>, Matt <jackdachef@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        htejun@gmail.com, linux-ext4@vger.kernel.org,
        Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption?
Message-ID: <20110106155641.GA12443@fancy-poultry.org>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
 <20101205100954.GA6564@fritha.org>
 <4CFB679D.5030900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFB679D.5030900@redhat.com>
Organization: private site
X-OpenPGP-KeyID: 0xE9002778
X-OpenPGP-Fingerprint: C661 CE20 7105 B0DB 49B5  CDB2 298C 801B E900 2778
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+20101028 (GNU/Linux)
X-Provags-ID: V02:K0:kGPp0YHvEkenAoO0lz+4ljy5GqsdRofXxUEGLCrI+sz
 f9CDxQ570m6t4JebV4TKf3RJ1wCT+U3hqbJwrbSnTUQ/uS3Tkx
 yzLVxjB/uf15FboWAACXfRKCj0WL0paXn0gFnzvI9n/y0IjWiK
 wMGyz1Ay1AzGUqPw5XGaoUMsXOB55vucOKyaF0hbNJyF/+Lzbv
 uLyMBxsqwF/E9EvoKufig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2010, Milan Broz wrote: 

> It still seems to like dmcrypt with its parallel processing is just
> trigger to another bug in 37-rc.

To come back to this: my 3 systems (XFS filesystem) running the latest 
dm-crypt-scale-to-multiple-cpus patch from Andi Kleen/Milan Broz have 
not showed a single problem since 2.6.37-rc6 and above. No corruption any 
longer, no freezes, nothing. The patch applies cleanly to 2.6.37, too, 
and runs just fine.

I blindly guess that my data corruption problem was related to something else in the
2.6.37-rc series up to -rc4/5.

Since this patch is a significant improvement: any chance that it finally gets 
merged into mainline/stable?

