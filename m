Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1DLMBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:01:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50145 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab1DLMBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HP7+h88y5vT1Gfby+8+JI/8M5eTHzS+39DWwE0phMXhWntnvhwIxSDkgfjerFuiR7K
         tKYVw4Zg/536rjJ5O1+IIykfErU35gtDXBvaisDM0voadnyv4Oru8hOx9FcW7LYkdoSi
         IDkXA//wyncbYg9xC+tKxRzOHlpZy0a7KzLjQ=
MIME-Version: 1.0
In-Reply-To: <20110412062416.GE1854@core.coreip.homeip.net>
References: <1302265424-4434-1-git-send-email-wanlong.gao@gmail.com>
	<20110412062416.GE1854@core.coreip.homeip.net>
Date: Tue, 12 Apr 2011 20:01:07 +0800
Message-ID: <BANLkTikDvdNa-Mob3oBwrqSqR3NmXPyo0w@mail.gmail.com>
Subject: Re: [PATCH] INPUT:Change a more clearly name for the input handlers' table
From: wanlong gao <wanlong.gao@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/11, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Fri, Apr 08, 2011 at 08:23:44PM +0800, wanlong.gao@gmail.com wrote:
>> From: Wanlong Gao <wanlong.gao@gmail.com>
>>
>> Change the input handlers' table name to input_handler_table for
>> making more clearly sense .
>>
>
> Sorry but I think the old name is fine. I'd rather see this table
> removed altogether and character devices pushed down into input handlers
> themselves.
If so , it will be a really hard work .
Thanks a lot.
>
> Thanks.
>
> --
> Dmitry
>
