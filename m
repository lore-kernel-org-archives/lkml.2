Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2CEGfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 01:35:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35949 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2CEGfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 01:35:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of corentin.chary@gmail.com designates 10.204.15.205 as permitted sender) smtp.mail=corentin.chary@gmail.com; dkim=pass header.i=corentin.chary@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F5370CD.3000501@suse.cz>
References: <1330714505-13170-1-git-send-email-jslaby@suse.cz>
	<CA+5PVA7=rMwMdvL+jY6nXS-RD8CCTTug6XZ6fmdzwHeksi79aw@mail.gmail.com>
	<CAHR064gbNSwHc=GVfm1R7LAmswJg_o7eW33cQ=JZHMJ8PMoVNw@mail.gmail.com>
	<4F5370CD.3000501@suse.cz>
Date: Mon, 5 Mar 2012 07:35:07 +0100
Message-ID: <CAHR064i0m_4=BntT-vpvdtM5MiuEku3jnYE1mB4BTUiSiztRMg@mail.gmail.com>
Subject: Re: [PATCH 1/1] samsung-laptop: add N230 to supported models
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org, mjg@redhat.com
Cc: Josh Boyer <jwboyer@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 4, 2012 at 2:40 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 03/04/2012 11:52 AM, Corentin Chary wrote:
>> On Fri, Mar 2, 2012 at 8:06 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>> On Fri, Mar 2, 2012 at 1:55 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>>>> There is a version of N230 which has only this in product and board
>>>> names. See dmidecode in the bugzilla entry.
>>>>
>>>> Without this patch, one has to pass the force module parameter to have
>>>> rfkill working.
>>>>
>>>> References: https://bugzilla.novell.com/show_bug.cgi?id=746695
>>>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>>>
>>> I think Corey has patches queued up in Matthew's git tree that drop the DMI
>>> checks in this driver entirely.  If so, this probably isn't needed.
>>
>> Right. You can try the out-of-tree module using this repository
>> https://github.com/iksaif/samsung-laptop-dkms . The patchs are in
>> Matthew queue and they should be merged in 3.4.
>
> Ok, thanks. Then please merge with -next ASAP.

Matthew, is your new tree
(git://cavan.codon.org.uk/platform-drivers-x86.git) merged in -next ?


-- 
Corentin Chary
http://xf.iksaif.net
