Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab1GRVSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:18:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58026 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1GRVSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:18:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVxR7AC7H_Yys8SiaGqM2JsNXLsRpujqojMYd_CXWxcAw@mail.gmail.com>
References: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<201107182041.EHB78622.VOFSHFMOOFtLJQ@I-love.SAKURA.ne.jp>
	<1310991796.3903.6.camel@smile>
	<201107182148.AGD21306.FOLtJVMSOOFQHF@I-love.SAKURA.ne.jp>
	<CAMuHMdVxR7AC7H_Yys8SiaGqM2JsNXLsRpujqojMYd_CXWxcAw@mail.gmail.com>
Date: Tue, 19 Jul 2011 00:18:31 +0300
Message-ID: <CAHp75VdTiMtmXdVSMq=6bAH2+rmSBHPPE9hQOLQN+Y3qPBEVFg@mail.gmail.com>
Subject: Re: [PATCH] Add error check to hex2bin().
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-security-module@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 11:49 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> What about making it return the number of unprocessed bytes left instead?
> Then the caller knows where the problem lies. And zero would mean success.
If I remember correctly it used to be src as return value in some
version of that patch. I don't know the details of that interim
solution. My current opinion is to return boolean and make an
additional parameter to return src value. However, it could make this
simple function fat.
P.S. Take into account that the user of it is only one so far, I would
like to hear a Mimi's opinion.

-- 
With Best Regards,
Andy Shevchenko
