Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1CYVbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:31:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58674 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab1CYVby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=k+wt3mkdmrP8x3607Hfub/nCi4DkGhiFk5OxwXphV8kGKBa9hO/4QerLMhIVLbs+c7
         BcehStZisSXkaPCr01JXvTsrJ2Z3IOSmcKwmNmzJFBW/bhx5+vt9UCbWMtLYNFjidWeY
         KOfH6uclQ9xT0c2LCKWIBOqnBFC7qUnclnvqI=
MIME-Version: 1.0
In-Reply-To: <20110325194946.GQ21838@one.firstfloor.org>
References: <1300914043-2297-1-git-send-email-abogani@kernel.org>
	<1300914043-2297-3-git-send-email-abogani@kernel.org>
	<m27hbov7hq.fsf@firstfloor.org>
	<8739mblr2n.fsf@rustcorp.com.au>
	<20110325154118.GN21838@one.firstfloor.org>
	<AANLkTinW4GA094Yz94Y0qTEJvjOmRe4_C+5yc7_VcKM3@mail.gmail.com>
	<20110325194946.GQ21838@one.firstfloor.org>
Date: Fri, 25 Mar 2011 22:31:53 +0100
X-Google-Sender-Auth: bCRvERleF1oi0JLIqLaZDboLKqM
Message-ID: <AANLkTinYY0vRzVHKqaZghiK=SvFUAVbM5s3Hf6H9C5Pv@mail.gmail.com>
Subject: Re: [PATCH 2/2] Replace the linear search with a binary search for
 locate the symbols
From: Alessio Igor Bogani <abogani@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Ian Lance Taylor <ian@airs.com>, Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Kleen,

2011/3/25 Andi Kleen <andi@firstfloor.org>:
> For kallsyms you either look it up by address or by name.

Sorry but I still don't understand the problem in particularly this
your sentence:

> You can only sort for one of those.

I have felt sure to have sorted both: indeed the linker sorts symbols
*before* it writes down their addresses (and not after). But I could
have made a mistake, obviously.

Could you pinpoint me to an sure method for clarify this point, please?

Thank you very much and sorry for my stupidity.

Ciao,
Alessio
