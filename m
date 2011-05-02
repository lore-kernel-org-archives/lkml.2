Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab1EBQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 12:16:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57443 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab1EBQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 12:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tHbp6As3Zzmaq2UnKjiHAwSAqueRZSGKhJVkk6wmx7T2S9uHLUuEu2DumpW6yUujsE
         mkIL3HFP7aJ+vUoCrGP8bGjEwR/W/7rVMy28V17FAXCz+GgQ8G6tZ6+SQDK9NpRBQVf2
         Jk8DkouJrZtH9d2yRLRNq11IS1+T5oyJ3nVsU=
MIME-Version: 1.0
In-Reply-To: <1304083893-18849-1-git-send-email-mmarek@suse.cz>
References: <71633.1304013549@localhost>
	<1304083893-18849-1-git-send-email-mmarek@suse.cz>
Date: Tue, 3 May 2011 00:16:15 +0800
Message-ID: <BANLkTikMf4x0e3UhabUH+c_xnWJMQ3rkvg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Valdis.Kletnieks@vt.edu, bp@alien8.de, sam@ravnborg.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 9:31 PM, Michal Marek <mmarek@suse.cz> wrote:
> Add support for make W=12, make W=123 and so on, to enable warnings from
> multiple W= levels. Normally, make W=<level> does not include warnings
> from the previous level.
>

This interface is not friendly, at least not as normal as we often see.
W=x+1 is supposed to include warnings of W=x.

Please refine the interface.

Thanks.
