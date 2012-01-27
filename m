Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab2A0XrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:47:19 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62620 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2A0XrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:47:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120127234140.GA19407@suse.de>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	<20120127234140.GA19407@suse.de>
Date: Fri, 27 Jan 2012 17:47:15 -0600
Message-ID: <CABqD9hZ9StgL_v-Z+hpGnbC6Ggu1N3hWXfV_gqUu6caCbcMCtQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] seccomp: kill the seccomp_t typedef
From: Will Drewry <wad@chromium.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, indan@nul.nu, mcgrathr@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 5:41 PM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Jan 27, 2012 at 05:24:39PM -0600, Will Drewry wrote:
>> Replaces the seccomp_t typedef with seccomp_struct to match modern
>> kernel style.
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  include/linux/sched.h   |    2 +-
>>  include/linux/seccomp.h |   10 ++++++----
>>  2 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 4032ec1..288b5cb 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1418,7 +1418,7 @@ struct task_struct {
>>       uid_t loginuid;
>>       unsigned int sessionid;
>>  #endif
>> -     seccomp_t seccomp;
>> +     struct seccomp_struct seccomp;
>
> Isn't 'struct seccomp_struct' a bit redundant?
>
> How about a simple 'struct seccomp' instead?

Works for me - I can't recall why that seemed to make sense (other
than the user of similar redundant names elsewhere).

> That is, if this is even needed...

I'd like to think it is :)

thanks!
will
