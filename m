Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1APLcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 06:32:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37082 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab1APLcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 06:32:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hxXgcVqQ4wYMnx83Supt7FBpr16jMpRBam1DMRt2yis1Fv6qVx8sWF10ewxmaizv+u
         dquXz/Q+bNSXHQngd0JtWvzxiu9gp2wqidfIo7ju3dkmosQbM7AZsVlnHVqX6AtuZcW8
         S8eMBUCWYPtY9QQ7adK6Q/R67Rzn3n+rmKM2Y=
Message-ID: <4D32D733.8090909@gmail.com>
Date: Sun, 16 Jan 2011 12:32:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Valdis.Kletnieks@vt.edu, autofs@linux.kernel.org,
        mm-commits@vger.kernel.org, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [autofs] WARNING: at fs/dcache.c:1359 d_set_d_op [was: mmotm
 2011-01-06-15-41 uploaded]
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>	 <4D2ECB56.4070802@gmail.com> <12521.1294932824@localhost>	 <4D2F1CD7.5090100@gmail.com> <1294993243.2794.4.camel@perseus>
In-Reply-To: <1294993243.2794.4.camel@perseus>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 09:20 AM, Ian Kent wrote:
> On Thu, 2011-01-13 at 16:40 +0100, Jiri Slaby wrote:
>> On 01/13/2011 04:33 PM, Valdis.Kletnieks@vt.edu wrote:
>>> On Thu, 13 Jan 2011 10:52:22 +0100, Jiri Slaby said:
>>>> On 01/07/2011 12:41 AM, akpm@linux-foundation.org wrote:
>>>>> The mm-of-the-moment snapshot 2011-01-06-15-41 has been uploaded to
>>>>
>>>> Hi, after some uptime and several suspend/resume cycles, I got:
>>>> WARNING: at fs/dcache.c:1359 d_set_d_op+0x82/0xb0()
>>>> Hardware name: To Be Filled By O.E.M.
>>>> Modules linked in: dvb_usb_af9015 tda18271 af9013 dvb_usb dvb_core
>>>> Pid: 3474, comm: automount Tainted: G        W   2.6.37-mm1_64+ #1344
>>>> Call Trace:
>>>>  [<ffffffff8106bd2a>] ? warn_slowpath_common+0x7a/0xb0
>>>>  [<ffffffff8106bd75>] ? warn_slowpath_null+0x15/0x20
>>>>  [<ffffffff81125a32>] ? d_set_d_op+0x82/0xb0
>>>>  [<ffffffff8120d829>] ? autofs4_dir_mkdir+0x169/0x180
>>>
>>> Wow. So it wasn't just configfs that trips over this one.  I'm now hoping that
>>> Al audited all the pseudo file systems for this...
>>
>> Well, CCing Al.
>>
>> I don't see any recent change in fs/autofs4 in:
>> http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=history;f=fs/autofs4;hb=refs/heads/for-next
>>
>> So maybe not all?
> 
> Did you see:
> https://lkml.org/lkml/2011/1/12/394

I haven't.

> Haven't had any feedback on this yet, odd or maybe no news is good news?

Works for me.

thanks,
-- 
js
