Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2LZBvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:51:41 -0500
Received: from intranet.asianux.com ([58.214.24.6]:22512 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab2LZBvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:51:39 -0500
X-Spam-Score: -100.8
Message-ID: <50DA585F.7000806@asianux.com>
Date: Wed, 26 Dec 2012 09:52:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/staging/tidspbridge: pr_err and pr_debug
 for uninitialized buffer (name buf not initialized).
References: <50C85644.7020203@asianux.com> <50C858AA.8080305@asianux.com> <CAJ6Av5OC+2wdfhb2FExv8NM7Hsyu4_1qnCWV22di8_psw4gF4Q@mail.gmail.com> <50CA8129.2020206@asianux.com> <CAJ6Av5PqZoW7s94J6MfmiN6kLzYZHH5Cv6qBA+xq65aPO0KA7g@mail.gmail.com>
In-Reply-To: <CAJ6Av5PqZoW7s94J6MfmiN6kLzYZHH5Cv6qBA+xq65aPO0KA7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月24日 22:26, Omar Ramirez Luna 写道:
> Hi,
> 
> On Thu, Dec 13, 2012 at 7:30 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>   also another suggestions:
>>     I built ti otmap with ti dsp bridge by arm cross-compiler under i386 platform.
>>     the version tag is next-20121213
>>     I met 2 compiling issues.
>>
>>       a: module dependency:
>>         Multifunction device drivers --> Texas Instruments TWL/4030/TWL5030.... is required for TI OTMAP.
>>         it need depend on CONFIG_REGMAP (maybe also inculde CONFIG_REGMAP*)
>>         if CONFIG_REGMAP* not defined, building will be failed.
> 
> This is not related to tidspbridge, I sent a patch anyway as it looks
> to be a valid build dependency bug.
> 


   thank you.

   :-)

-- 
Chen Gang

Asianux Corporation
