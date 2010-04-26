Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab0DZS6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:58:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:55697 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0DZS6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=rB+tSJQ+HlSm+RFZcIgck6M8SkcoaScJ2NuAINCZyic/GmGXMAhjFgKPqgp7oZvr3t
         WOlUng5SZbaT6/zv/8LnWAMv0Dbxyer9pv4gum5h7tHmocjjq2759h6AGs+l2yVnUFjg
         Gt77cW16KNipdjVq8M7Pa+CygrNVWGvjyn3vA=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Manuel Lauss <manuel.lauss@googlemail.com>
Subject: Re: 2.6.34-rc5+: oops in IPv6
Date: Mon, 26 Apr 2010 20:58:24 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc5; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <z2if861ec6f1004250745u94892bdbw9b17db4be57b131b@mail.gmail.com>
In-Reply-To: <z2if861ec6f1004250745u94892bdbw9b17db4be57b131b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004262058.24465.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 25 kwietnia 2010 o 16:45:41 Manuel Lauss wrote:
> 2.6.34-rc5-00204-gddc9b34  dies when sshd (openssh 5.5) is started
> Last pull I made on April 23 was fine.
> 
> (transcribed from a photo):
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000004
> IP: [<b1535b72>] inet6_csk_bind_conflict+0x6e/0xb0

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15857
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
