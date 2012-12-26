Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2LZGnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 01:43:47 -0500
Received: from intranet.asianux.com ([58.214.24.6]:22720 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2LZGno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 01:43:44 -0500
X-Spam-Score: -100.8
Message-ID: <50DA9CD2.70607@asianux.com>
Date: Wed, 26 Dec 2012 14:44:34 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        eballetbo@iseebcn.com
Subject: Re: [Suggestion] drivers/staging/tidspbridge: pr_err and pr_debug
 for uninitialized buffer (name buf not initialized).
References: <50C85644.7020203@asianux.com> <50C858AA.8080305@asianux.com> <CAJ6Av5OC+2wdfhb2FExv8NM7Hsyu4_1qnCWV22di8_psw4gF4Q@mail.gmail.com> <50CA8129.2020206@asianux.com> <CAJ6Av5PqZoW7s94J6MfmiN6kLzYZHH5Cv6qBA+xq65aPO0KA7g@mail.gmail.com> <50DA593E.9000707@asianux.com> <CAJ6Av5PkPa_20xUYjd1h71ajZOoDxjw2sGKUrfEjb4SuoFc4bg@mail.gmail.com>
In-Reply-To: <CAJ6Av5PkPa_20xUYjd1h71ajZOoDxjw2sGKUrfEjb4SuoFc4bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月26日 14:28, Omar Ramirez Luna 写道:
> 
> I also sent a patch for this:
> 
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg82565.html
> 
> However, I just saw this one which was sent 6 days ago:
> 
> https://patchwork.kernel.org/patch/1895081/
> 
> The latter includes the new header file, mine just the definitions
> needed, any approach is fine by me as they both fix the compile break.
> 
> Cheers,
> 
> Omar
> 
> 

  ok, thanks

by the way:
  the suggestion is sent in 2012-12-14 which is earlier than 2012-12-19
    ref: http://www.gossamer-threads.com/lists/linux/kernel/1646629
         at 3rd reply.

  :-)

-- 
Chen Gang

Asianux Corporation
