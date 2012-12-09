Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2LISaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 13:30:04 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55747 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab2LISaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 13:30:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAJL_dMs9PJYuiuLLPxFWbrQ2Q5w3FXgAAs1+0UCtUTUiXfp5=g@mail.gmail.com>
References: <50C25146.9010909@ubuntu.com>
	<CAJL_dMs9PJYuiuLLPxFWbrQ2Q5w3FXgAAs1+0UCtUTUiXfp5=g@mail.gmail.com>
Date: Sun, 9 Dec 2012 20:30:01 +0200
Message-ID: <CAJL_dMuj=naZCmkE=RHjQkF5g1jXRCqTzqkbJ=c7UcRzatP2Aw@mail.gmail.com>
Subject: Re: Upstart 1.6.1 released
From: Anca Emanuel <anca.emanuel@gmail.com>
To: james.hunt@ubuntu.com
Cc: "upstart-devel >> Upstart Devel List" 
	<upstart-devel@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, you need more testing with ARM Nexus 7 ?

On Sun, Dec 9, 2012 at 8:28 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> Do will see this in Raring ?
> And when ?
>
> On Fri, Dec 7, 2012 at 10:27 PM, James Hunt <james.hunt@ubuntu.com> wrote:
>> Summary of changes:
>>
>> * Improved re-exec performance.
>> * Minor logger fixes for unflushed data.
>> * Handle re-exec scenario when requested from within a chroot.
>> * Minor serialisation data format change to handle chroots and
>>   user sessions.
>> * Added extra re-exec tests including explicit upgrade tests reading
>>   from pre-prepared JSON data files.
>> * Make jobs running within a chroot log their output within the chroot.
>> * Added "Restart" D-Bus method.
>> * Changed 'telinit u' to use "Restart" D-Bus method rather than
>>   sending SIGTERM to play nicely when busybox(1) is init.
>> * Added "GetState" D-Bus method allowing current serialised internal state
>>   to be queried.
>>
>> Thanks to all the contributors, reviewers, testers and users!
>>
>> Download it from launchpad: https://launchpad.net/upstart
>>
>> Kind regards,
>>
>> James.
>> --
>> James Hunt
>> ____________________________________
>> http://upstart.ubuntu.com/cookbook
>> http://upstart.ubuntu.com/cookbook/upstart_cookbook.pdf
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
