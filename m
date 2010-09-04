Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0IDNe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 09:34:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33881 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab0IDNe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 09:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=v8rpICsCetajODCr3eeaDjmmWMSKaKEEV73avDUVoXe7oVGb5uTwhGGlqU85riRmIJ
         BPChpbGcXZtlMbmX3AD9wBugXHspcBR/ZSjVUzXjY9OgDbN8wGI4WfV77GEz5/IrBDGP
         pTZLWDhL1aJpqV11zniADxjl519HU46T8qyJU=
Subject: Re: Nouveau driver fails
From: Calvin Walton <calvin.walton@gmail.com>
To: piotr@hosowicz.com
Cc: LKML <linux-kernel@vger.kernel.org>, nouveau@lists.freedesktop.org
In-Reply-To: <4C80DBE5.1040701@example.com>
References: <4C80DBE5.1040701@example.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Sep 2010 09:34:23 -0400
Message-ID: <1283607263.9039.15.camel@ayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 13:28 +0200, Piotr Hosowicz wrote:
> Hello,
> 
> Nouveau driver seems to fail. Please find attached Xorg.0.log, lspci and 
> kernel config. My card is 01:00.0 VGA compatible controller: nVidia 
> Corporation G96 [GeForce 9400 GT] (rev a1). Tried with today's Linux Next.

You might get better results asking the nouveau developers directly -
I've added the nouveau mailing list to the CC.

(http://www.spinics.net/lists/kernel/msg1079386.html has the attachments
archived.)

-- 
Calvin Walton <calvin.walton@gmail.com>

