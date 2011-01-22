Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab1AVLDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 06:03:40 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54970 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1AVLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 06:03:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JGBOgz+2SuSawJnw5yrmGZQtVbkkEXSFwXiuseRffYzA8ofRoUL4LZ5Mo36u4S4usY
         WPVTuJ0y/NzGme/PKZ7VT7uyglEbkv/D6GLRVIx1UDZGOfUKd6tESMhJAnaBIbWRvwsZ
         CQ+dCaHwqw1bTSqD/h3w0MO1HDQTocrhfCuJw=
MIME-Version: 1.0
In-Reply-To: <AANLkTik-7tOEzwgk=xy6q756uayxjTy9Nx3XiQKtXSLs@mail.gmail.com>
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
	<AANLkTik-7tOEzwgk=xy6q756uayxjTy9Nx3XiQKtXSLs@mail.gmail.com>
Date: Sat, 22 Jan 2011 13:03:38 +0200
X-Google-Sender-Auth: 55nBaFD_c7eHsE4sEzh1qq7gp_U
Message-ID: <AANLkTi=b5B7W3_P06j87fPno0TT6Ket4A3qzmMeAbUj-@mail.gmail.com>
Subject: Re: [PATCH 0/7] Nexus One Support
From: Pekka Enberg <penberg@kernel.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Dima Zavin <dmitriyz@google.com>, "Ted Ts'o" <tytso@mit.edu>,
        Daniel Walker <dwalker@codeaurora.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 12:45 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> Can you show how to import history ? Until then, a line like From:
> x@y.x I think will be fine.
> And maybe an link to https://review.source.android.com/'some review'

The best solution is to keep the original patches as-is and rebase
Daniel's cleanups on top of those.
