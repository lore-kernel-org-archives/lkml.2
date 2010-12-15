Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0LOTRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:17:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60573 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0LOTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:16:58 -0500
Date: Wed, 15 Dec 2010 20:16:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matt <jackdachef@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>,
        Chris Mason <chris.mason@oracle.com>, Andi Kleen <andi@firstfloor.org>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Message-ID: <20101215191655.GA6163@basil.fritz.box>
References: <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
 <20101212023415.GG3059@thunk.org>
 <AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
 <AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
 <20101212124354.GA4513@thunk.org>
 <AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=@mail.gmail.com>
 <20101213020657.GB4513@thunk.org>
 <AANLkTinMWS-yyzWJ3oBo_KS9jXt4p4pveo+SPTLiWnCt@mail.gmail.com>
 <AANLkTimjM_HptLaCSuQivxruWpoc7todyMe0wnszrSYU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimjM_HptLaCSuQivxruWpoc7todyMe0wnszrSYU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a question though: the deactivation of multiple page-io
> submission support most likely only would affect bigger systems or
> also desktop systems (like mine) ?

I think this is not a final fix, just a workaround.
The problem with the other path still really needs to be tracked down.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
