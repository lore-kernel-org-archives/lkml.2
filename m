Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1GYXwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:52:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61026 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1GYXw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <1311637788.3526.38.camel@gandalf.stny.rr.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	<1311618747.3526.32.camel@gandalf.stny.rr.com>
	<CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	<1311625197.3526.35.camel@gandalf.stny.rr.com>
	<CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
	<1311637788.3526.38.camel@gandalf.stny.rr.com>
Date: Mon, 25 Jul 2011 19:52:26 -0400
Message-ID: <CACqU3MWc7fknt9vJfKfFcv0Oe6CYSGmgMy87e+W=7D74tCKv1g@mail.gmail.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Arnaud Lacombe <lacombar@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 25, 2011 at 7:49 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-07-25 at 18:38 -0400, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Mon, Jul 25, 2011 at 4:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Mon, 2011-07-25 at 15:43 -0400, Arnaud Lacombe wrote:
>> >
>> >> Actually, we have a special uninitialized_var(x) macro to handle such
>> >> false positive. From include/linux/compiler-gcc.h:
>> >>
>> >> /*
>> >>  * A trick to suppress uninitialized variable warning without generating any
>> >>  * code
>> >>  */
>> >> #define uninitialized_var(x) x = x
>> >
>> > I'm aware of that too, but I think that is inappropriate as well. As I
>> > said, some versions of gcc report it, others don't. Seems that gcc 4.6.0
>> > says this is an error where 4.5.1 does not (I just tried both).
>> >
>> did you ? gcc 4.5.1 from Fedora 14 definitively shows the warning:
>
> Heh, I didn't use Fedora's version. I wonder if they added a patch or
> built it differently. I built my own 4.5.1 as well as my own 4.6.0.
>
I'd assume you're building with -O2, the warning only shows up at -Os,
see my previous mail.

 - Arnaud
