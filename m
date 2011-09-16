Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab1IPB1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 21:27:43 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:50614 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1IPB1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 21:27:42 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzEedjD0vqemMhYEEH99ya6tk9X4ViGwm_vuVy-41w3=A@mail.gmail.com>
References: <web-606439650@zbackend1.aha.ru> <CA+55aFwyC7s=YK10Wkpr+GzdukXp-JUtf_=MgWcrhBOtTg4eTg@mail.gmail.com>
 <web-606798161@zbackend1.aha.ru> <CA+55aFwBuySWa2VErrfud_SFqyfT5ib+Qfq9gWBaBz=cQ6VcHg@mail.gmail.com>
 <web-606831561@zbackend1.aha.ru> <CAObL_7F2Pu0K1Oe3oLe5Pef2kaGE8vdO2qgfc0KEt8TJdUaOWg@mail.gmail.com>
 <CAObL_7E0iyinOyXU=uQHyQN+TBNmVVB89r_hQUb8LTqJ2ix_5A@mail.gmail.com>
 <CA+55aFzay+U5JA0Q6vdjmV73yG0OUXnO_zi6Q0c6iTkmozSSiw@mail.gmail.com>
 <web-607296211@zbackend1.aha.ru> <CAObL_7HAxg0j3ywpTy1-5Y5vBBQLSTiF7AZ0bctRsPOLKA8ZNA@mail.gmail.com>
 <CA+55aFwEKNEN8QPpBhAkDQ4UGFtSDtpdwFRSkTvnhaYRTmrsOA@mail.gmail.com>
 <CAObL_7Gjk91MFSwbaMnfdxwrM0mDGxWtDBaKMoimg2FSUqjAUg@mail.gmail.com>
 <CA+55aFxmW7rFEpanD-ngB-Egx5j1q8b_u31Keo3+s-TJ13UZGA@mail.gmail.com>
 <CA+55aFxcibMZbEpJzP-LfV1aYFM-n9ctEqNMZ_k4XJxoZPfbrg@mail.gmail.com>
 <web-607463067@zbackend1.aha.ru> <CA+55aFzEedjD0vqemMhYEEH99ya6tk9X4ViGwm_vuVy-41w3=A@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 15 Sep 2011 18:27:21 -0700
X-Google-Sender-Auth: fmcblAv4yPYONocCtLskAeNYuPI
Message-ID: <CAObL_7EuUyeJ2ebhMhYgY_4O+wUE-rHbc4aBvEKaGrimxU_z7A@mail.gmail.com>
Subject: Re: 3.1-rc6 boot problem reason searching
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/15 Linus Torvalds <torvalds@linux-foundation.org>:
> On Thu, Sep 15, 2011 at 6:10 PM, werner <w.landgraf@ru.ru> wrote:
>> Meanwhile 3.1-rc6 with the patch by L.T. is compiled, and it boots, with the
>> original allyesconfig with M486 , so that insofar that problem is resolved.
>> So that 95% of the population of poorer parts of the world (which have 486
>> computers) continue to be benefited also by version 3.1 .
>
> Thanks for testing.. I suspect you're the only one who ever actually
> builds i486 kernels any more - at least development kernels ;)

Would you prefer for me to test your patch or to submit my one-liner?

--Andy

>
>                  Linus
>
