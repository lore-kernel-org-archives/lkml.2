Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0JFS7R convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Wed, 6 Oct 2010 14:59:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60639 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab0JFS7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=rh0MeGQC1B7wskd4nyxflmrR/E4M3yDylH5gOVDqVw4pTCTDM3KaF/MjPpIhRsCi3I
         /kUkDNbJv5rbZL4gmZCOVuavtljFsTK/z4SA6dUcxf25QODb+6u5dSrY7L/9R3LxPABa
         xGTuMjVIwE3QROEE4f5zxwqJ6ANx6IGJnSbo8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Sven Neumann <s.neumann@raumfeld.com>
Subject: Re: 2.6.35.6 fails to suspend (pxa2xx-mci.0)
Date: Wed, 6 Oct 2010 20:59:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6; KDE/4.4.5; i686; ; )
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Daniel Mack <daniel@caiaq.de>
References: <1286177435.2140.5.camel@sven>
In-Reply-To: <1286177435.2140.5.camel@sven>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Message-Id: <201010062059.09020.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from QUOTED-PRINTABLE to 8bit by mail.home.local id o96J0aud025963

On poniedziałek, 4 października 2010 o 09:30:35 Sven Neumann wrote:
> Hi,
> 
> we are running an embedded system here based on the PXA300 platform.
> Suspend/resume used to work well so far. However after upgrading the
> kernel from 2.6.34.7 to 2.6.35.6, we get the following error when trying
> to suspend the system:
>
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=19792
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
