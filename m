Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2EZOSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 10:18:18 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62454 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2EZOSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 10:18:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy9QysTkgPuy=GPxknRMoPTSTmp3FkHFJ+bs0G6CSh41g@mail.gmail.com>
References: <CAO_48GFE3=yQjKS4w7=pGjNe3yENbRrd4bcMTfADJSn7LKekPQ@mail.gmail.com>
 <CAO_48GGRRvCKVyY_s=oFgTb1vfjf8pSkHRf3jA8iFcdEHhwxVg@mail.gmail.com> <CA+55aFy9QysTkgPuy=GPxknRMoPTSTmp3FkHFJ+bs0G6CSh41g@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Sat, 26 May 2012 19:47:54 +0530
Message-ID: <CAO_48GEzhmme8Evt9xiowgAwm_4496F9RTsO5ej3Fwtyr5VUVA@mail.gmail.com>
Subject: Re: [GIT PULL]: dma-buf updates for 3.5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Jesse Barker <jesse.barker@linaro.org>, akpm@linux-foundation.org,
        Daniel Vetter <daniel@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 25 May 2012 22:14, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Fri, May 25, 2012 at 2:17 AM, Sumit Semwal <sumit.semwal@linaro.org> wrote:
>>
>> I am really sorry - I goofed up in the git URL (sent the ssh URL
>> instead).
>
> I was going to send you an acerbic email asking for your private ssh
> key, but then noticed that you had sent another email with the public
> version of the git tree..
Well, it was stupid indeed - learning for me; won't happen again.
>
>> Could you please use
>>
>> git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git tags/tag-for-linus-3.5
>>
>> instead, or should I send a new pull request with the corrected URL?
>
> Done. However, while your tag seems to be signed, your key is not
> available publicly:
>
>   [torvalds@i5 ~]$ gpg --recv-key 7126925D
>   gpg: requesting key 7126925D from hkp server pgp.mit.edu
>   gpgkeys: key 7126925D not found on keyserver
>
> so I can't check if it is signed by anybody.
>
> Please do something like
>
>   gpg --keyserver pgp.mit.edu --send-keys 7126925D
>
> to actually make your public key public.
Thanks; it is done.
>
> Of course, if it isn't public, I assume it hasn't actually been signed
> by anybody, which makes it largely useless. But any future signing
> action will validate the pre-signing uses of the key, so that's
> fixable.

Like Arnd has mentioned, we would do a key signing party here at the
Linaro meeting, and make sure that relevant ones are signed.
>
>                     Linus
-- 
Thanks and best regards,
~Sumit
