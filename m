Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab1E0AEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 20:04:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64417 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1E0AEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 20:04:32 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=wom5GMh1gUkA:10 a=tyV8ermOv9cA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=Z4Rwk6OoAAAA:8 a=hBqU3vQJAAAA:8 a=l09RzYvU5Unt_6K13oIA:9 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=4gZ4WExUoD4A:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Thu, 26 May 2011 19:04:31 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        David Howells <dhowells@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] Set cred->user_ns in key_replace_session_keyring
Message-ID: <20110527000431.GA13999@mail.hallyn.com>
References: <20110526202505.GA6367@mail.hallyn.com>
 <BANLkTi=dhwdPGj=yU=NRaSkK-BBTPQNKOA@mail.gmail.com>
 <20110526203819.GA27529@mail.hallyn.com>
 <BANLkTikjL9znUnsAKhJfThEMtJ2aevAF-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikjL9znUnsAKhJfThEMtJ2aevAF-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (torvalds@linux-foundation.org):
> On Thu, May 26, 2011 at 1:38 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> >
> > Stable/whoever, should I re-send this patch separately, or does this suffice?
> 
> I'll add the Cc and update the description to point to the commit it
> was introduced in, and it will all be fine. Then the stable team will
> get it automatically when I push out.
> 
>                           Linus

Thanks very much.  (I see now)

-serge
