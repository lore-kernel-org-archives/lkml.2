Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1LWCZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 21:25:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57586 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1LWCZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 21:25:50 -0500
MIME-Version: 1.0
In-Reply-To: <20111222190359.GF604@animx.eu.org>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
 <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
 <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com> <20111222190359.GF604@animx.eu.org>
From: Gaurav Saxena <grvsaxena419@gmail.com>
Date: Fri, 23 Dec 2011 07:55:18 +0530
Message-ID: <CAOh0hwOJ7F8JPFtnO1CnUiLcBtx=V9WEjVLJ7c0+t4j57s07Og@mail.gmail.com>
Subject: Re: Intercepting system calls
To: wakko@animx.eu.org, Gaurav Saxena <grvsaxena419@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wakko

On Fri, Dec 23, 2011 at 12:33 AM, Wakko Warner <wakko@animx.eu.org> wrote:
> Gaurav Saxena wrote:
>> Oh. I will not do it then, could you suggest me something so that I
>> could prevent unlink on some file say using kernel support. I want to
>> save file on unlink how could I do that without kernel support, or how
>> could I do that using a kernel module.
>
> I wrote a library that can be loaded in userspace that does this.  It's not
> very polished, but it works for me.  I use it for rsync when I want files
> "deleted" but not from the filesystem.  It creates a .deleted directory in
> the $PWD.
> If you're interested, I can send it to you.  I have it working on i386 and
> amd64.
Yes I am a lot interested I would customize it to suit my purposes.
Does it work on linux >3.0
>
> --
>  Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
>  million bugs.



-- 
Thanks and Regards ,
Gaurav
