Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2ABW3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 17:29:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37749 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab2ABW3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 17:29:11 -0500
Message-ID: <4F022FB4.5080703@openvz.org>
Date: Tue, 03 Jan 2012 02:29:08 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: cleanup prohibition of direct opening for unix98
 pty master
References: <20120102172231.11476.57711.stgit@zurg> <20120102172844.GA19782@suse.de>
In-Reply-To: <20120102172844.GA19782@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jan 02, 2012 at 09:22:31PM +0400, Konstantin Khlebnikov wrote:
>> cleanup hack added in v2.6.27-3203-g15582d3
>>
>> comment from that patch:
>>
>> : pty: If the administrator creates a device for a ptmx slave we should not error
>> :
>> : The open path for ptmx slaves is via the ptmx device. Opening them any
>> : other way is not allowed. Vegard Nossum found that previously this was not
>> : the case and mknod foo c 128 42; cat foo would produce nasty diagnostics
>> :
>> : Signed-off-by: Alan Cox<alan@redhat.com>
>> : Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>
>
> Any reason why you didn't include these two people on this patch?
> Perhaps they might wish to review it...

This is just simple cleanup patch.

>
> greg k-h

