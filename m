Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1AVLPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 06:15:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57806 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1AVLPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 06:15:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YWcAVeLKkVT0cwTAbrDNd0C2zWm2rR5lGaecJfwW7Nxv2/EdMwp1RwTK196BkEq/cT
         urfElKEshzvKYACdGhNaAclEjGAeNccTwJGgTcQk5vUQi9kC7uCzNlljxnfbM164zvdS
         Nf0+NRx2RKTn8baqmhjvd0ihh2sVlJwAV1F2A=
MIME-Version: 1.0
In-Reply-To: <AANLkTinEnNYjhA2WRD=1AqmHYY3ec0uJxRVmLW57_EU=@mail.gmail.com>
References: <1295576730.4096.24.camel@Joe-Laptop>
	<1295624801.19880.13.camel@m0nster>
	<20110121094827.41818a55@jbarnes-desktop>
	<20110121095658.1ab623fe@jbarnes-desktop>
	<1295632828.19880.22.camel@m0nster>
	<20110121100441.06a94482@jbarnes-desktop>
	<1295633882.19880.31.camel@m0nster>
	<AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
	<1295642995.19880.42.camel@m0nster>
	<AANLkTikVDn+W8t7KSym5tCGZowyYvoLFrk8d0mumiRF-@mail.gmail.com>
	<20110121234930.GK3043@thunk.org>
	<1295684398.19231.47.camel@jaguar>
	<AANLkTinEnNYjhA2WRD=1AqmHYY3ec0uJxRVmLW57_EU=@mail.gmail.com>
Date: Sat, 22 Jan 2011 13:15:38 +0200
X-Google-Sender-Auth: s5g7NxRJaagcy3xmP-RZA9ISzSU
Message-ID: <AANLkTikrDxtkVFJ0C-SwH9QCq4m0A2KMp0vAFA=PaSGM@mail.gmail.com>
Subject: Re: [PATCH 0/7] Nexus One Support
From: Pekka Enberg <penberg@kernel.org>
To: Dima Zavin <dmitriyz@google.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Daniel Walker <dwalker@codeaurora.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dima!

On Sat, Jan 22, 2011 at 12:35 PM, Dima Zavin <dmitriyz@google.com> wrote:
> There's absolutely no hostility. I stated from the very beginning that
> I appreciate the voluntary effort by a 3rd party to upstream the board
> files. I only asked that proper authorship be attributed, which is
> standard linux kernel patch submission procedure when the committer
> did not originate the code.

OK, that's great! It's poorly reflected in this discussion thread, though.

>> who have been sitting on these patches for over a year now AFAICT.
>
> Even if that were true, that does not somehow revoke the original
> author/contributor list.

No, it does not. But it does make me much more sympathetic towards
Daniel's efforts even though authorship info is misappropriated. It's
not as if he changed copyrights or anything malicious like that so I
do think people are making this into a bigger thing than it really is.

Anyway, I hope Daniel has the time to rebase his patches on top of
your original ones so history is preserved and we can get this stuff
merged.

                       Pekka
