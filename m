Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2IJImM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:42:12 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38157 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab2IJIly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:41:54 -0400
MIME-Version: 1.0
In-Reply-To: <201209071358.38598.arnd@arndb.de>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<201209071241.17198.arnd@arndb.de>
	<20120907130114.GF29601@gmail.com>
	<201209071358.38598.arnd@arndb.de>
Date: Mon, 10 Sep 2012 01:41:52 -0700
Message-ID: <CACRpkdZ-QpHzeEBO=RFVe-8S2DG4-thhwW9iVbAMXZrOe-FnAw@mail.gmail.com>
Subject: Re: [PATCH 00/19] First HREF Device Tree enablement patch-set
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 3:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 07 September 2012, Lee Jones wrote:
>> (...)
>> Linus wanted to keep changes to the Device Tree and changes
>> in platform code separate, which is my reason for submitting
>> all of my changes to date that way.
> (...)
> Linus: What is the reason you want to see the commits split up
> like this?

Basically that was at a point when we were changing a lot of
subsystem trees with DT patches that were merged in out-of-order
fashion.

Then it's better to have the DT changes to be pushed
separately at the end of the merge window after all subtrees
with dependent changes are merged. (Or even in the next merge
window if there is no hurry, but we always seem to be in a hurry...)

If all the changes are in the same subtree (like ARM SoC with
ACKs from all over the place where needed) you can do it
this way instead, and I agree it looks better.

So basically two different merge strategies get you to split
patches differently.

Any way is fine with me, do as Arnd suggests if all is going
in through ARM SoC.

Yours,
Linus Walleij
