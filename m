Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab2EGLpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:45:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47094 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab2EGLpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:45:02 -0400
MIME-Version: 1.0
In-Reply-To: <0Lutsn-1Rz44S07BR-0105dP@mrelayeu.kundenserver.de>
References: <0MOCMW-1SHWKu3g28-005WSP@mrelayeu.kundenserver.de>
	<CACRpkdb=aXHrXWEEZHpJup-rzd385Rew6QfF=ZhPRM8pBs+8hQ@mail.gmail.com>
	<0Lutsn-1Rz44S07BR-0105dP@mrelayeu.kundenserver.de>
Date: Mon, 7 May 2012 13:45:01 +0200
Message-ID: <CACRpkdZvOmt2BKWEUt-H9N43+dqrHhqtZrjEbWrsurB=QAvLtQ@mail.gmail.com>
Subject: Re: [PATCH v2] Add support for TCA6424A
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 2:52 PM, Andreas Schallenberg
<Andreas.Schallenberg@3alitytechnica.com> wrote:
> On 25.04.2012 19:06, Linus Walleij wrote:
>>
>> Looks good to me. Would be good to have this tested on the other family
>> members though.
>
> I agree. However, I don't have other HW to test with. Is this a case for the
> "staging" branch then?

There is no such thing as a staging branch. Staging is where we throw in
entire drivers ... I'd say just apply it and see if something breaks in
linux-next, it's as good smoke test as any.

Yours,
Linus Walleij
