Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0EGORz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:17:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59758 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0EGORy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:17:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=fOa3lJGHC5EJfTFrU+xaoYslaUkqOWscCcrRAh8d9FuV6h+ssreFoySP/YHZKiyGJj
         8aBSocA4gDnp0DvW7GVqfl1JuyJyjXayaQV6GuechibPE3iJNOiMV87xTcHzt+/ZZzdz
         y+/BYAVyGuOyHGV9+X47TBjSmFNEEC2oR9GG8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: subrata@linux.vnet.ibm.com
Subject: Re: Suspicious rcu_dereference_check() usage detected during 2.6.34-rc6 boot on PPC64/p5 processor
Date: Fri, 7 May 2010 16:17:49 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6; KDE/4.3.4; i686; ; )
Cc: "Linuxppc-dev" <Linuxppc-dev@ozlabs.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1273130279.4898.5.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1273130279.4898.5.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005071617.49253.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 6 maja 2010 o 09:17:59 Subrata Modak wrote:
> Hi,
> 
> The following messages were logged into /var/log/messages when i booted
> 2.6.34-rc6 kernel (built with attached CONFIG file contents ) on my p5 box:
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15936
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
