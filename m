Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab2IMLrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:47:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53898 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab2IMLq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:46:59 -0400
Message-ID: <5051C7AD.7050005@suse.cz>
Date: Thu, 13 Sep 2012 13:46:53 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
References: <20120913095623.GB28508@moon>
In-Reply-To: <20120913095623.GB28508@moon>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 11:56 AM, Cyrill Gorcunov wrote:
> For checkpoint/restore we need to know if tty has
> exclusive or packet mode set, as well as if pty
> is currently locked. Just to be able to restore
> this characteristics.
> 
> For this sake the following ioctl codes are introduced
> 
>  - TIOGPKT to get packet mode state
>  - TIOGPTLCK to get Pty locked state
>  - TIOGEXCL to get Exclusive mode state

Hi! I have only a comment regarding the naming. Why not to follow TIOC*?

thanks,
-- 
js
suse labs
