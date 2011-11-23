Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab1KWSFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:05:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43247 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab1KWSFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:05:43 -0500
MIME-Version: 1.0
In-Reply-To: <20111123171245.3e3f18a7@lxorguk.ukuu.org.uk>
References: <CAKYAXd965Md2D4mnDbROoNcKZPQs2dERh8y7aDHtoJ+FJcK1QQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1111231131100.2111-100000@iolanthe.rowland.org>
	<20111123171245.3e3f18a7@lxorguk.ukuu.org.uk>
Date: Wed, 23 Nov 2011 23:30:16 +0530
Message-ID: <CADDb1s2OcfjwAJoTTbR6547hDL68PJFg_jD_vAs-nGmgiO6YWQ@mail.gmail.com>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>, NamJae Jeon <linkinjeon@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        Unix Support <unix-support@ucs.cam.ac.uk>,
        Steve French <smfrench@gmail.com>, akpm@linux-foundation.org,
        Anton Altaparmakov <aia21@cam.ac.uk>, ashishsangwan2@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
Ok, translations cannot be added easily. But any idea why surrogate
pairs are not handled? I think handling for surrogate pairs can be
added by identifying proper points(there are not many I guess). Please
share your views.

Regards,
Amit Sahrawat

On Wed, Nov 23, 2011 at 10:42 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 23 Nov 2011 11:31:47 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
>
>> On Wed, 23 Nov 2011, NamJae Jeon wrote:
>>
>> > Hi. Alan.
>> > Would you know why there is no upper/lower case table in nls utf8 ?
>> > And Currently Surrogate pair is not supported also in nls utf8. Is
>> > there the reason ?
>>
>> I don't know.
>
> For one case translations are locale specific and very very complicated.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
