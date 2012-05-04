Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab2EDUjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:39:16 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35586 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab2EDUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:39:15 -0400
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: Handling of modular boards
MIME-Version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
In-reply-to: <4FA432E9.9050606@wwwdotorg.org>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com> <4FA432E9.9050606@wwwdotorg.org>
Comments: In-reply-to Stephen Warren <swarren@wwwdotorg.org>
   message dated "Fri, 04 May 2012 13:50:01 -0600."
Date: Fri, 04 May 2012 22:38:57 +0200
Message-Id: <20120504203857.49EAD206451@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Stephen,

In message <4FA432E9.9050606@wwwdotorg.org> you wrote:
>
> representation of how to identify the child boards, and then have the
> kernel only use/parse certain chunks of the DT based on the ID results.

I expect that this will quickly cause problems, for example in those
many cases where pins and peripheral functions are multiplexed, or
usable for different purposes. I would not want to maintain a DT that
has to describe all combinations used by some boards - in a way that
does not cause conflicts on either of them.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
CONSUMER NOTICE:  Because  of  the  "Uncertainty  Principle,"  It  Is
Impossible  for  the  Consumer  to  Find  Out  at  the Same Time Both
Precisely Where This Product Is and How Fast It Is Moving.
