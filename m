Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab0LTQE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:04:58 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:62586 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab0LTQEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:04:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jDIT/7cqz5fAzwJWvbPoDw3CRwzoR2oY8gZqdisExzKpLrT+6uUOqmPdSLENw8Dc7u
         xxH+m7ymYnEDeM++pwpIbGMX3mBYOUEfX4vaXT8r3vbO1WFpwvD+UPq3QmGiSbolkpRQ
         t4AG4eOkKoS3xKlpdsqQPCreSG5V9L9q5ONfk=
MIME-Version: 1.0
In-Reply-To: <20101220160018.GE26766@linux-sh.org>
References: <20101220130314.GA3627@alchark-u3s>
	<20101220130957.GB3627@alchark-u3s>
	<20101220160018.GE26766@linux-sh.org>
Date: Mon, 20 Dec 2010 19:04:53 +0300
Message-ID: <AANLkTik9kD3gW1dQ6xe-jpyK9RQxOQJofekaO9Z9FXcC@mail.gmail.com>
Subject: Re: [PATCH 2/2] fbdev: Modify vsync timing calculation in wm8505fb
From: Alexey Charkov <alchark@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "Janorkar, Mayuresh" <mayur@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/20 Paul Mundt <lethal@linux-sh.org>:
> On Mon, Dec 20, 2010 at 04:09:57PM +0300, Alexey Charkov wrote:
>> This removes the '+1' in vsync timing calculation for wm8505fb to
>> directly use values provided from the board setup code.
>>
>> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>
> This is queued for .37, thanks.
>

Paul, in fact, relevant code is only scheduled for merge in .38 (it is
in linux-next right now). This does not apply to .37.

Thanks,
Alexey
