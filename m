Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1BYGVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:21:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33093 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1BYGVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:21:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=vk/T2cqlya/FA/bhQ19bYPp2eVHnmFTmWLAV4NBsqPquKVt3wUqQVtBlevFlKSEO3R
         5TyVafCDMbB6RKu93pX438foNn8gynvvM1KctyoM9moSszHy2rFYgyLGygdGPz20Ompb
         GYfJKNLrr8UXuLaFa3MwLne8I9HDa5+Pr/ZAQ=
MIME-Version: 1.0
In-Reply-To: <1298614522-4153-1-git-send-email-justinmattock@gmail.com>
References: <1298614522-4153-1-git-send-email-justinmattock@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 25 Feb 2011 17:20:49 +1100
Message-ID: <AANLkTi=FuD0FCTv6f0sPKkg14O9R_giKi9uvA0Xsgy1q@mail.gmail.com>
Subject: Re: [PATCH 18/21]include:net:mac80211.h remove one to many l's in the word.
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 17:15, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> The patch below removes an extra "l" in the word.

Random thought:

Not that I'm complaining about your work here, and not that commits
are a finite resource, but would it be possible for you to collect
your spelling changes into slightly bigger commits before sending them
off?

E.g. instead of sending off 21 patches to remove 21 erroneous l's, why
not do a full spelling check on these 21 files, then send off 21
patches to fix *all* the spelling mistakes in each file? You could
even group them up by directory if you liked.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
