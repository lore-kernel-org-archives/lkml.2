Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0JDNqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:46:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47115 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab0JDNqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:46:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xu7lUUiq50H8FkNKSGwWe0vq5q0gV/pm/AJhUzlE8i2lZ5tdJf3nB8nBtk0zQtOmmo
         BUZ/+6TEDHSLe60km5Wh68wQuDVpMD6/a/+J20kNHb5sU3RNK95gA1Gl9pvHOTYE4X0T
         7pPbjZUxqwu/dGhd4fAdiunEZSKVyU3oj8NLU=
MIME-Version: 1.0
In-Reply-To: <4CA9D97A.7020109@suse.cz>
References: <AANLkTinwXj92VLVYqDhvUAusY_MdBQPAYnGBKVgfNLrO@mail.gmail.com>
	<20100924093206.GD5453@cr0.nay.redhat.com>
	<AANLkTi=ykH+gTujw+x1c107V6wXfZUT66uHBQ1o6NgK+@mail.gmail.com>
	<4CA9D97A.7020109@suse.cz>
Date: Mon, 4 Oct 2010 14:46:48 +0100
Message-ID: <AANLkTim5cNUT+pN7Ay3Wf-VxTrfUc2h=G=tYPtBn=tsU@mail.gmail.com>
Subject: Re: [PATCH] kconfig: Use PATH_MAX instead of 128 for path buffer sizes.
From: Will Newton <will.newton@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 2:41 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 4.10.2010 15:00, Will Newton wrote:
>> On Fri, Sep 24, 2010 at 10:32 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> On Wed, Sep 22, 2010 at 03:59:13PM +0100, Will Newton wrote:
>>>> This prevents the buffers being overflowed when using a config
>>>> file with a long name. PATH_MAX is used elsewhere in the same
>>>> file, so use it here as well.
>>>>
>>>> Signed-off-by: Will Newton <will.newton@imgtec.com>
>>>
>>> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>>>
>>> Thanks!
>>
>> Ping!
>>
>> Could someone take this please?
>
> Sorry, applied now. BTW, please do not send patches inline _and_ as
> attachments at the same time, it confuses git am.

Thanks!

The reason I send the patches in both ways is because last time I
checked the gmail web interface will mangle an inline patch, but not
an attached one, and most people like an inline patch for review
purposes. I'll have to check to see if there's another way to avoid
that problem.
