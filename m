Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018Ab2J1KEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 06:04:52 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64384 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2J1KEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 06:04:50 -0400
Message-ID: <508D033E.8030109@suse.cz>
Date: Sun, 28 Oct 2012 11:04:46 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Stanislav Kozina <skozina@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 3.7-rc1
References: <20121001183046.GA13042@kroah.com> <506A0FCA.2020908@suse.cz> <20121001221350.GA10172@kroah.com>
In-Reply-To: <20121001221350.GA10172@kroah.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 12:13 AM, Greg KH wrote:
> On Mon, Oct 01, 2012 at 11:48:58PM +0200, Jiri Slaby wrote:
>> On 10/01/2012 08:30 PM, Greg KH wrote:
>>> Stanislav Kozina (2):
>>>       tty: Fix possible race in n_tty_read()
>>
>> The (pretty hopeless) commit log says:
>>     Fix possible panic caused by unlocked access to tty->read_cnt in
>>     while-loop condition in n_tty_read().
>>
>> Just curious, what kind of panic that can cause, can you be more
>> concrete on that? I suppose two readers, one eats everything, the other
>> is a killer? And should we backport to -stable?
> 
> Stanislav, you are the one who could reproduce this, any answers here?

Ping?

-- 
js
suse labs
