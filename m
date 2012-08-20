Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2HTGcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:32:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53153 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2HTGcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120819120804.15c33931@pixies.home.jungo.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
 <1345214124-5478-6-git-send-email-richard.genoud@gmail.com> <20120819120804.15c33931@pixies.home.jungo.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 20 Aug 2012 08:31:39 +0200
Message-ID: <CACQ1gAgLirwiwiUOoL7ig7R_RpB8xDr2-g2gVOEUZNvAHB60pQ@mail.gmail.com>
Subject: Re: [PATCH 5/8] UBI: check max_beb_per1024 value in ubi_attach_mtd_dev
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shmulik,

2012/8/19 Shmulik Ladkani <shmulik.ladkani@gmail.com>:
> Hi Richard,
>
> On Fri, 17 Aug 2012 16:35:21 +0200 Richard Genoud <richard.genoud@gmail.com> wrote:
>> +     /*
>> +      * A value of 0 is forced to the default value to keep the same
>> +      * behavior between ubiattach command and module parameter
>> +      */
>
> Minor thing.
>
> Since the module parameter is not yet introduced (only in a later
> patch), and since last part of sentence isn't that important, I would
> simply state:
>
> +        * Use the default if max_beb_per1024 isn't provided.
>
That's right, I'll correct that in next version.
Thanks !
