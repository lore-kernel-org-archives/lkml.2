Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2DPVIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:08:49 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4154 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab2DPVIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:08:47 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
Message-ID: <4F8C8A4F.3060208@broadcom.com>
Date: Mon, 16 Apr 2012 23:08:31 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Felipe Contreras" <felipe.contreras@gmail.com>
cc: "Ingo Molnar" <mingo@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Sergio Correia" <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "linux-wireless Mailing List" <linux-wireless@vger.kernel.org>,
        "Sujith Manoharan" <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
References: <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
 <CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
 <CA+55aFwaOGbD6S_7So34ZuANG-6fZXZhEah8G0X7McDGhionSg@mail.gmail.com>
 <CAMP44s06jrPBzf5Lt86-GDxD_PxqcaeJgmYS4tJhcvDdf=J5zA@mail.gmail.com>
 <20120414104733.GA4871@gmail.com>
 <CAMP44s0tBbgmunXTN9Jyw=HHnXFyvRY3qo5Vf-jXETUM4HEGWA@mail.gmail.com>
 <20120415065124.GC29563@gmail.com>
 <CAMP44s3mOsCGG5_gd6zTUeXewTFKeVEmAkt2FvM=wTm-5AEC+w@mail.gmail.com>
 <CA+55aFz8oepgj7W8W=d18qwQt3JUGgv+pCto-_2WS3WJ3ZKqzQ@mail.gmail.com>
 <CAMP44s2vx5cn_=tRD46SqAobRceLiZDfi9-zLUnv_g89wLxryQ@mail.gmail.com>
 <20120416053220.GA14338@gmail.com>
 <CAMP44s1j297wO8TJgto+w1x3G0qTC=BehuKtE2TZnxYmdoM=Fg@mail.gmail.com>
In-Reply-To: <CAMP44s1j297wO8TJgto+w1x3G0qTC=BehuKtE2TZnxYmdoM=Fg@mail.gmail.com>
X-WSS-ID: 639253433IO5756224-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 10:25 PM, Felipe Contreras wrote:
> Releasing implies many things. There is this notion called theory of
> mind, which children learn at a very young age, that helps us see the
> world through the eyes of other people. If you think people *must* see
> the word "release" and think *exactly* the same thing as  you do, and
> apologize when they don't, well, I'd say you are missing a very
> valuable skill.

Maybe we are all a bit autistic then.

> But fine, lets suppose I should have thought exactly the same thing as
> you did, and fine, lets say I was wrong in not doing so. That still
> doesn't help one iota in this discussion. Linus Torvalds pointed the
> exact reason, which allowed us to move forward, because of my
> incompetence, or whatever.

I think this thread has been going on long enough and a fair number of 
people tried to explain the process and why it is set up as such. How 
long do you want to rephrase and stick to your "theory of mind". Email 
filters will probably be created rather sooner than later. Does 
Contreras have the same linguistic origin as "contrary"? Sorry, could 
not think of anything constructive here.

> The next logical question has still not been answered; does the
> undroppability come from the fact that v3.4 is more important that
> v3.3.1? This time I promise to think at least one day for all the
> possible meanings of each key word you say.

3.4 is not most important, but upstream is and currently those are the 
3.4-rcN releases. Every patch has to go upstream first as it was, is, 
and will be our past, present, and future.

The only thing I can think of in favor of your arguments is that the 
name 'stable' imply that they are without issues, ie. stable. However, 
with a bit of ToM you may see that they are maintenance releases.

Gr. AvS


