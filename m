Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab0LPUtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:49:24 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:54256 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab0LPUtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:49:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=WManPZSZf70aa77apTHD1iqFprAyMX7+6EzLkDa/Ap28UZt1jtNzqYdkugHlEPLfOo
         cJDtNzsRDlYy9nmHHBcQ02NMeJ1mS4Y4S3PLKpf4XEAdZrtpxKE7Dp1X2dMYyOmO1S4D
         SG4j4USJmqJIqSlGosBfz2WlEeSrwR/jeijRw=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: =?utf-8?q?T=C3=B5nu_Raitviir?= <jussuf@linux.ee>
Subject: Re: BUG: i915 causes NULL pointer dereference in 2.6.37-rc5-git4
Date: Thu, 16 Dec 2010 21:49:12 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5; KDE/4.4.5; i686; ; )
Cc: chris@chris-wilson.co.uk, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1012151238570.4797@jbbyvx.ohzcpyho.rr>
In-Reply-To: <alpine.DEB.2.00.1012151238570.4797@jbbyvx.ohzcpyho.rr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012162149.12475.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 15 grudnia 2010 o 11:48:21 Tõnu Raitviir wrote:
> Asus P5E-VM HDMI motherboard with G35 chipset, only HDMI output is
> connected. Last known good kernel was 2.6.36.2
> 
> 00:02.0 VGA compatible controller: Intel Corporation 82G35 Express
> Integrated Graphics Controller (rev 03) 00:02.1 Display controller: Intel
> Corporation 82G35 Express Integrated Graphics Controller (rev 03)

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=25012
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
