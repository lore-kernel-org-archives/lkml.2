Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0EGOAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:00:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38224 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0EGOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Ev0AHzjPZyvgoRgAu91MdYRnkARWBllvJZpupeVtzm8TZ9dEbxdNPcHQpJud8vfmVu
         5womXEz6FaK3Burhi8kf99kGvFSVunuCr3Td9K4nBl0N1JvELHeOlpq/jw0gXdpVW8Q7
         WUxGphQvPAu4H8sY9GaKOwW73STpEM6HfFzq0=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [BUG] btrfs: report a direct-IO bug
Date: Fri, 7 May 2010 16:00:35 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6; KDE/4.3.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-btrfs@vger.kernel.org
References: <4BE21FC1.1010901@cn.fujitsu.com>
In-Reply-To: <4BE21FC1.1010901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005071600.36060.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 6 maja 2010 o 03:47:45 liubo wrote:
> When we tested the series of jim owens' direct-IO patch, a bug occured.
> 
> It could be reproduced on a 2.6.34-rc6 kernel with
> direct-IO patch by the following steps...
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15935
for your bug report, please add your address to the CC list in there, thanks!
 

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
