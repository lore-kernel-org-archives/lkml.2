Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1DURbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:31:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45288 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab1DURbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=toc270SF7MRMDCX6WuVJ8Wrd9JKuJfRXkiXO47PRnYQo/hftA6EJ0lL4PLCxTHYB/k
         pLgdSYpoFx6tBR0QISeDNiXz1fahQDmvDOsbkeR0U3cmJ5e0roiZtxfopa1UWReeV+Ra
         fwK/gUWVMHlOez/Npv4tVIBGV+xEYoaGjpw50=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Dave Jones <davej@redhat.com>
Subject: Re: lockdep trace when unplugging usb audio (.39rc4)
Date: Thu, 21 Apr 2011 19:31:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc3; KDE/4.4.5; i686; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
References: <20110419180745.GA438@redhat.com>
In-Reply-To: <20110419180745.GA438@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104211931.43057.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 19 kwietnia 2011 o 20:07:45 Dave Jones wrote:
> I get this trace when I unplug my NuForce uDAC.
> 
> 	Dave
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=33792
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
