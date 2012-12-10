Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2LJJB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:01:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51445 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2LJJBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:01:55 -0500
Message-ID: <50C5A501.8000509@ubuntu.com>
Date: Mon, 10 Dec 2012 09:01:53 +0000
From: James Hunt <james.hunt@ubuntu.com>
Reply-To: james.hunt@ubuntu.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: "upstart-devel >> Upstart Devel List" 
	<upstart-devel@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Upstart 1.6.1 released
References: <50C25146.9010909@ubuntu.com> <CAJL_dMs9PJYuiuLLPxFWbrQ2Q5w3FXgAAs1+0UCtUTUiXfp5=g@mail.gmail.com> <CAJL_dMuj=naZCmkE=RHjQkF5g1jXRCqTzqkbJ=c7UcRzatP2Aw@mail.gmail.com>
In-Reply-To: <CAJL_dMuj=naZCmkE=RHjQkF5g1jXRCqTzqkbJ=c7UcRzatP2Aw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/12 18:30, Anca Emanuel wrote:
> Oh, you need more testing with ARM Nexus 7 ?
If that's an offer, feel free to drop in on #upstart / #ubuntu-arm and get
involved ;)

> 
> On Sun, Dec 9, 2012 at 8:28 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>> Do will see this in Raring ?
>> And when ?
This week - we're currently preparing the updated package.

>>
>> On Fri, Dec 7, 2012 at 10:27 PM, James Hunt <james.hunt@ubuntu.com> wrote:
>>> Summary of changes:
>>>
>>> * Improved re-exec performance.
>>> * Minor logger fixes for unflushed data.
>>> * Handle re-exec scenario when requested from within a chroot.
>>> * Minor serialisation data format change to handle chroots and
>>>   user sessions.
>>> * Added extra re-exec tests including explicit upgrade tests reading
>>>   from pre-prepared JSON data files.
>>> * Make jobs running within a chroot log their output within the chroot.
>>> * Added "Restart" D-Bus method.
>>> * Changed 'telinit u' to use "Restart" D-Bus method rather than
>>>   sending SIGTERM to play nicely when busybox(1) is init.
>>> * Added "GetState" D-Bus method allowing current serialised internal state
>>>   to be queried.
>>>
>>> Thanks to all the contributors, reviewers, testers and users!
>>>
>>> Download it from launchpad: https://launchpad.net/upstart
>>>
>>> Kind regards,
>>>
>>> James.
>>> --
>>> James Hunt
>>> ____________________________________
>>> http://upstart.ubuntu.com/cookbook
>>> http://upstart.ubuntu.com/cookbook/upstart_cookbook.pdf
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
> 

Kind regards,

James.
--
James Hunt
____________________________________
http://upstart.ubuntu.com/cookbook
http://upstart.ubuntu.com/cookbook/upstart_cookbook.pdf
