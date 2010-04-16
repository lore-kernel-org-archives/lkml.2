Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab0DPOle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:41:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:33852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab0DPOld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=dReVZw/qBJJu8vkeeGBPqNhXSwhxgPvG9lHqC7QSkrzkHT6Z4hJtAJ8297NHJ0WJSM
         dhwZvpTTbQLhiCziZvXjI3vVbo252i38kcNf8G0SSJrm4TfDrBrRqGWeC/1hTbqIFUSn
         fOf9W5TRlFlwRokd2OZJ/ZQVZAYm4jOIVw4FI=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: 2.6.34-rc4 : OOPS in unmap_vma
Date: Fri, 16 Apr 2010 16:41:29 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
In-Reply-To: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004161641.29193.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 14 kwietnia 2010 o 03:53:46 Parag Warudkar wrote:
> Not sure if this is related to the recent mm/vma fixes - got this
> while rebooting (kexec) latest git -
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15795
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
