Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab2IETr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:47:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39929 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759201Ab2IETr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:47:26 -0400
Message-ID: <5047AC47.8080808@canonical.com>
Date: Wed, 05 Sep 2012 12:47:19 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] security: allow Yama to be unconditionally stacked
References: <20120904203213.GA3617@www.outflux.net> <20120905154753.GE14225@amd1> <CACLa4pvcqXfArSmm3bRadJF9unafyko9T4F9OfwUYTgHdfU49g@mail.gmail.com>
In-Reply-To: <CACLa4pvcqXfArSmm3bRadJF9unafyko9T4F9OfwUYTgHdfU49g@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 11:32 AM, Eric Paris wrote:
> On Wed, Sep 5, 2012 at 11:47 AM, Serge Hallyn
> <serge.hallyn@canonical.com> wrote:
>> Quoting Kees Cook (keescook@chromium.org):
>>> Unconditionally call Yama when CONFIG_SECURITY_YAMA_STACKED is selected,
>>> no matter what LSM module is primary.
>>>
>>> Ubuntu and Chrome OS already carry patches to do this, and Fedora
>>> has voiced interest in doing this as well. Instead of having multiple
>>> distributions (or LSM authors) carrying these patches, just allow Yama
>>> to be called unconditionally when selected by the new CONFIG.
>>
>> I don't really like having both the STACKED and non-stacked paths. But
>> I don't have a good alternative.
>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> 
> I said basically the same thing to Kees off list.  But I don't have an
> answer either.
> 
> Acked-by: Eric Paris <eparis@redhat.com>
> 
Yeah I'm not fond of it either but until some more generic form of LSM
stacking arives, I don't see a good alternative either

so until then

Acked-by: John Johansen <john.johansen@canonical.com>

