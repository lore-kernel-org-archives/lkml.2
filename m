Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab2IEScW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:32:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64307 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759143Ab2IEScT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:32:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120905154753.GE14225@amd1>
References: <20120904203213.GA3617@www.outflux.net>
	<20120905154753.GE14225@amd1>
Date: Wed, 5 Sep 2012 14:32:17 -0400
Message-ID: <CACLa4pvcqXfArSmm3bRadJF9unafyko9T4F9OfwUYTgHdfU49g@mail.gmail.com>
Subject: Re: [PATCH] security: allow Yama to be unconditionally stacked
From: Eric Paris <eparis@parisplace.org>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 11:47 AM, Serge Hallyn
<serge.hallyn@canonical.com> wrote:
> Quoting Kees Cook (keescook@chromium.org):
>> Unconditionally call Yama when CONFIG_SECURITY_YAMA_STACKED is selected,
>> no matter what LSM module is primary.
>>
>> Ubuntu and Chrome OS already carry patches to do this, and Fedora
>> has voiced interest in doing this as well. Instead of having multiple
>> distributions (or LSM authors) carrying these patches, just allow Yama
>> to be called unconditionally when selected by the new CONFIG.
>
> I don't really like having both the STACKED and non-stacked paths. But
> I don't have a good alternative.
>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>

I said basically the same thing to Kees off list.  But I don't have an
answer either.

Acked-by: Eric Paris <eparis@redhat.com>
