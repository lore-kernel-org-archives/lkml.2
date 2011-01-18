Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1ARDJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 22:09:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63709 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1ARDJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 22:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=qFLmbcrdOkvonYst0ipHEDZD5jLygu3qsQMUIWvZfwmxF20mdMCtAUKWAVdn2PeIR6
         AmdrrFzdiSTjo2WYojCks/HJ0wAV0W9JgB7x7cx6uHfw+BxyKJis0oO2+o5/+u4QIWlI
         qtadxkMx47sNT0wk0pltfEFPBM+GpOezBi8PA=
MIME-Version: 1.0
In-Reply-To: <1295288462.3335.55.camel@edumazet-laptop>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
 <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com> <1295288462.3335.55.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Tue, 18 Jan 2011 11:08:42 +0800
Message-ID: <AANLkTi=YU-JeKFtD6iDEuH+JsK2EHmGnq3ehXfy+-AA8@mail.gmail.com>
Subject: Re: [PATCH v2] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com, bhutchings@solarflare.com, joe@perches.com,
        dilinger@queued.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eric,

On Tue, Jan 18, 2011 at 2:21 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> BTW, shouldnt you use cpu_to_be32() or cpu_to_le32(), if this driver is
> multi platform ?

This reminds me another thing. Should I use u32 instead of unsigned int for all
hardware related variables (registers, descriptors) ?
Not quite sure about these cross-platform issues.

best regards,
Po-Yu Chuang
