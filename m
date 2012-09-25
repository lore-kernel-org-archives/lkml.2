Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2IYIzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:55:04 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33510 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2IYIy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:54:59 -0400
Message-ID: <50617171.8030601@gmail.com>
Date: Tue, 25 Sep 2012 10:55:13 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Sasha Levin <sasha.levin@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tty ldisc lockups in linux-next
References: <50617008.5000207@oracle.com> <506170BB.4040005@suse.cz>
In-Reply-To: <506170BB.4040005@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 10:52 AM, Jiri Slaby wrote:
>> Hi all,
>> > 
>> > While fuzzing with trinity in a KVM tools guest running linux-next kernel, I keep hitting the following lockup:
> Hi, I'm confused here. Is this different to what you reported a couple
> days ago? Doesn't reverting aa3c8af86382 help in the end?

I was just about to send a reply to that mail saying that while reverting aa3c8af86382 reduces the odds for seeing it, it still
happens. You were faster than me :)

But yes, it still happens even if I revert aa3c8af86382 or try applying your patch in that thread.


Thanks,
Sasha

