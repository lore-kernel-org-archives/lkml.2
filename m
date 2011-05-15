Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1EOR3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:29:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44605 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1EOR3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=waO+OL5E3EVP18HIjfSdSP9NDLcbf0hdfR5YLXTzVEkEYoRoEOiGcU7yMRV+it1dl4
         UQO2A2TtGrKUj47g/sNPMExPcdelWlv0fKsNvQDTvaFSmZhTQAwd4oY0ZjA5E4AD/IdA
         z0XHSbNXmXdKoxwWSmLs1a3l9HeBwREgnJ63o=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Andrew Lutomirski <luto@mit.edu>
Subject: Re: [2.6.39 regression] X locks up hard right after logging in
Date: Sun, 15 May 2011 19:29:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc6; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <BANLkTinWePJ9N8D=JSezOfiQ94qp2bDGrw@mail.gmail.com>
In-Reply-To: <BANLkTinWePJ9N8D=JSezOfiQ94qp2bDGrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105151929.33278.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=35152
for your bug report, please add your address to the CC list in there, thanks!

On czwartek, 12 maja 2011 o 15:31:49 Andrew Lutomirski wrote:
> I just installed 9f381a6 (-linus from yesterday) on my Sandy Bridge
> desktop, and it locks up hard within a few seconds of logging in.
> netconsole says:
> 
> [  506.629723] block group 24725422080 has an wrong amount of free space
> [  506.629723] block group 24725422080 has an wrong amount of free space
> [  506.808501] fuse init (API version 7.16)
> [  506.819996] SELinux: initialized (dev fuse, type fuse), uses
> genfs_contexts [  506.829847] SELinux: initialized (dev fusectl, type
> fusectl), uses genfs_contexts
> [  506.808501] fuse init (API version 7.16)
> [  506.819996] SELinux: initialized (dev fuse, type fuse), uses
> genfs_contexts [  506.829847] SELinux: initialized (dev fusectl, type
> fusectl), uses genfs_contexts
> 
> If it's any help, the system is locked so hard that the reset button
> doesn't work.  It's an Intel DQ67SW board, which apparently doesn't
> have the most reliable reset button in the world :)
> 
> 2.6.38.{4,5,6} are all rock-solid on this box.
> 
> I've started bisecting, but I don't expect to finish today.  I need to
> do some work other than kernel hacking...
> 
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
