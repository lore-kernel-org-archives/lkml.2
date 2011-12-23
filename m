Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab1LWOiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 09:38:15 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:34740 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1LWOiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:38:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20212.37458.896503.997111@quad.stoffel.home>
Date: Fri, 23 Dec 2011 09:38:10 -0500
From: "John Stoffel" <john@stoffel.org>
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: John Stoffel <john@stoffel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Intercepting system calls
In-Reply-To: <CAOh0hwPeveaEaNv_mjNVLM36JSbObX4n5y1jC_Yp5MwdBA0Sxw@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
	<CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
	<CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
	<20211.28256.111279.27933@quad.stoffel.home>
	<CAOh0hwPeveaEaNv_mjNVLM36JSbObX4n5y1jC_Yp5MwdBA0Sxw@mail.gmail.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Gaurav" == Gaurav Saxena <grvsaxena419@gmail.com> writes:

Gaurav> Hello John,
Gaurav> On Thu, Dec 22, 2011 at 11:22 PM, John Stoffel <john@stoffel.org> wrote:
>>>>>>> "Gaurav" == Gaurav Saxena <grvsaxena419@gmail.com> writes:
>> 
>>>> Intercepting system calls is very bad, don't do it.
>> 
Gaurav> Oh. I will not do it then, could you suggest me something so
Gaurav> that I could prevent unlink on some file say using kernel
Gaurav> support. I want to save file on unlink how could I do that
Gaurav> without kernel support, or how could I do that using a kernel
Gaurav> module.
>> 
>> Write a FUSE module to mount the filesystem through, inside your FUSE
>> module you can intercept the unlink/truncate/write calls and decide
>> what you want to have happen.

Gaurav> I would like to write it differently for each type of filesystem ?
Gaurav> Because what operations to call after my function depends on this.
Gaurav> Also Can I mount "/" in this way ?

Sounds like you really want to use inotify() then, but intercepting
calls to write/truncate/unlink isn't going to be easy to handle across
a large spectrum of filesystems without a bunch of hacking.  

Maybe if you can explain your requirements more clearly, with an
example of what you're trying to accomplish, then people could help
you more.

Also, it might be more appropriate to talk to the 'fs-devel' mailing
list.  I think it's on kernel.org, but not sure.

John

