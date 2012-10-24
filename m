Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab2JXRK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:10:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44171 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab2JXRKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:10:54 -0400
MIME-Version: 1.0
In-Reply-To: <E86B2A8F-3C10-4B35-9F33-98D5A927E1E7@gmail.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-107-git-send-email-keescook@chromium.org>
	<E86B2A8F-3C10-4B35-9F33-98D5A927E1E7@gmail.com>
Date: Wed, 24 Oct 2012 10:10:52 -0700
X-Google-Sender-Auth: jueJ-tE0ppwGgEWwjo9RH-cTMPM
Message-ID: <CAGXu5jJLEg8iOXVk6pD8LN5UPmX+riO1_+0hoeDQQty0VXp+AA@mail.gmail.com>
Subject: Re: [PATCH 106/193] drivers/net/wireless/rt2x00: remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 9:21 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
>
> On 23 okt. 2012, at 22:02, Kees Cook <keescook@chromium.org> wrote:
>
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, remove it.
>>
>> CC: Ivo van Doorn <IvDoorn@gmail.com>
>> CC: Gertjan van Wingerde <gwingerde@gmail.com>
>> CC: Helmut Schaa <helmut.schaa@googlemail.com>
>> CC: "John W. Linville" <linville@tuxdriver.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> I don't have a problem with the removal of the CONFIG_EXPERIMENTAL dependency, but I would like to retain the (EXPERIMENTAL) tag in the option string. We can then remove those tags when the support for those devices stabilize.

Sure thing! I've updated the patch.

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
