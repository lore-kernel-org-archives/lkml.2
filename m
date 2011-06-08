Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab1FHTex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:34:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43140 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab1FHTes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Aip2qaarz+zOSwX8/YZ7kV959gOSbWInE2Nc7MUo6PIgqw37WVhWsp8F7EKAJ8jIKE
         Jg986UxnZcz1D00TpnDnAmAk41KMyXxKR7QOigY3y9T/ZklQ63EtrOJDxRnEkiVK6TS5
         rfwSJdGtXSgZgUl3Av3GJopHbzxeeLaHrWahQ=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Helge Hafting <helge.hafting@hist.no>
Subject: Re: [2.6.39] CIFS write failures where 2.6.38 works
Date: Wed, 8 Jun 2011 21:34:42 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1; KDE/4.4.5; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4DE6103E.6010100@hist.no>
In-Reply-To: <4DE6103E.6010100@hist.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106082134.42506.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=36952
for your bug report, please add your address to the CC list in there, thanks!

On środa, 1 czerwca 2011 o 12:11:10 Helge Hafting wrote:
> At work I use cifs for accessing a windows server. This has worked fine
> for a long time, up to and including Debian's 2.6.38-2.
> 
> I just installed Debians's 2.6.39-1, and had to give up on it.
> Mounting CIFS works, and I can see the files. But if I
> try to make a new file (with cp), I get a long delay.
> 
> In this time, anything accessing CIFS will pause, including "ls".
> CIFS eventually becomes unstuck, and I will find that my "ls" succeeded,
> but the file copy did not. The file was created, but
> with 0 size.
> 
> Trying to copy the file again results in another stall, and so on.
> 
> 
> When I mount CIFS, I get this message:
> CIFS VFS: Unexpected SMB signature
> 
> This happens with 2.6.38 as well as 2.6.39.
> 
> When writes fail in 2.6.39, I also get:
> CIFS VFS: Send error in Close = -512
> 
> Followed by:
> CIFS VFS: Server servername has not responded in 300 seconds.
> Reconnecting...
> 
> I have also seen
> CIFS VFS: Send error in Close = -512
> and
> CIFS VFS: Send error in read = -13
> 
> Helge Hafting
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
