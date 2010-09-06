Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab0IFFdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 01:33:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57333 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0IFFdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 01:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V3vcnBO/c7TXV1ig5rNLAhrK5fyA9kZ4is6al9KeAb5CrW0+dYdIOkXU4HIOten1dk
         YJ49RYHdPJp44Je7oE8AM8mulcfzeX8/Jak/nzcVTu1unjLvieP6cQWcu19NxP3J4xIY
         +GV4kYwH1zPN+LqIuWrfTLiVixB92x1Cd+wtE=
MIME-Version: 1.0
In-Reply-To: <m38w3hqx8g.fsf@pullcord.laptop.org>
References: <4C82419C.3050903@suse.cz>
	<m38w3hqx8g.fsf@pullcord.laptop.org>
Date: Mon, 6 Sep 2010 11:03:13 +0530
Message-ID: <AANLkTin+T2tB+oXu9BzUfBkPpxEe47+tSMr2Yf4_Lb=x@mail.gmail.com>
Subject: Re: HIDDEV: potential NULL dereference
From: Amit Nagal <helloin.amit@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <error27@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

i was one of the users who informed that crash do disappears .

the reality with me is that the probability of occurence of crash
reduces significantly

but on rigourous testing crash resurfaces again .

sorry for wrong reporting .

Regards
Amit Nagal



On Sat, Sep 4, 2010 at 10:09 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi Jiri,
>
>   > If hid was ever NULL at this phase, the check couldn't improve
>   > anything due to hid->driver_data dereference being still before
>   > the check. So again my question, how this could change anything?
>   >
>   > Above that, it just makes the window shorter, but the bug is
>   > still there, isn't it? Is the following scenario reasonable?
>
> You're right -- I'd missed the other dereference, sorry.  It's
> surprising that we have two reports from users saying that the
> patch got rid of a reproducible oops for them.
>
> Dan Carpenter has commented on this too:
>   http://www.spinics.net/lists/linux-input/msg10541.html
>
> As he says, it looks like the code's overdue for some real locking.
>
> Thanks,
>
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
