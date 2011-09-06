Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1IFPER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:04:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39524 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab1IFPEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:04:11 -0400
MIME-Version: 1.0
In-Reply-To: <4E65DF36.6040507@parrot.com>
References: <4E65DF36.6040507@parrot.com>
Date: Tue, 6 Sep 2011 11:04:08 -0400
Message-ID: <CACqU3MU9nuW+a3AJfY_PRqFH_tgaKtBJrp1pU2xpB_dHYANBXg@mail.gmail.com>
Subject: Re: randconfig broken on choice
From: Arnaud Lacombe <lacombar@gmail.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 6, 2011 at 4:52 AM, Matthieu CASTET
<matthieu.castet@parrot.com> wrote:
> Hi,
>
> I am using v3.1-rc4 and make randconfig look broken for choice.
> The choice config is always the same or choice entry can have more than one entry.
>
Could you includes testcases showing that behavior, please ?

Btw, try also to include patch inlined, not multipart. That makes
review easier. I know, gmail is not making that easy, but git
send-email works just fine.

Thanks,
 - Arnaud

>
> After some debugging, it seems in randomize_choice_values, we don't clean
> SYMBOL_VALID for choice entry.
> And we don't take "sym->def[S_DEF_USER].tri" but the "default sym->cur.tri".
>
> The following patch seems to fix the problem.
>
>
> Matthieu
>
