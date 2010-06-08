Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0FHTZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:25:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33010 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab0FHTY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=xOZTvQUCRwXfD+ICO9jth9+W/lFQMv8G+4+UZFw8eLZHA+HmcskHpBQxRFG6KVNvUr
         JNVHFAJb9+WOrplJ/4A/DPazo8BLRUO5uJVvsJOs1FBcXv+zljnMX6c60aIBPk1NGcr9
         RVFefjRik21Jag5M0huSZe1YTWlpUW6JDRt/4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Dave Airlie <airlied@gmail.com>
Subject: Re: SSD + sata_nv + btrfs oops
Date: Tue, 8 Jun 2010 21:24:52 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Chris Mason <chris.mason@oracle.com>
References: <AANLkTilqsIdlzZgUf7TMLHYKqHDZoVkcs42vcG8wXKEr@mail.gmail.com>
In-Reply-To: <AANLkTilqsIdlzZgUf7TMLHYKqHDZoVkcs42vcG8wXKEr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006082124.52549.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 1 czerwca 2010 o 05:04:33 Dave Airlie wrote:
> Hi guys,
> 
> I've been running an Intel SSD (the KS one) on my Dell XPS710 desktop
> machine, with btrfs on it.
> 
> I'm not sure the btrfs oops isn't due to the disk/controller doing
> something bad (almost guaranteed).
> 
> Attached the dmesg + config, using 2.6.34 + only drm patches.
> 
> Jeff I'd be interested in knowing what is happening to the disk before
> btrfs oops.
> 
> Dave.
> 
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16162
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
