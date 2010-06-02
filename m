Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab0FBOec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:34:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55898 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab0FBOea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=xOPb38lMMbO6xN93klQYANYICF7IqO1PhO/+/w//1GiJlxWwRZxAF4cPZDQOcfrrcP
         oTnAlrdw0OWN1zSSUuMyvvq4odSAjdbSFrUoE8f061QDZacH23YAbs3SlPi2ENzzROhK
         m6ZpLx96/r4NrcIfkCSmjxm+1hf3zF5hDozns=
MIME-Version: 1.0
In-Reply-To: <AANLkTikC61Y9g-WbqwgGDghDSy2XtgraFSRoZYkHRGTG@mail.gmail.com>
References: <AANLkTikC61Y9g-WbqwgGDghDSy2XtgraFSRoZYkHRGTG@mail.gmail.com>
Date: Wed, 2 Jun 2010 20:04:28 +0530
Message-ID: <AANLkTilEYHVHJrj_KgF48OYCSEUcsKLi57Q_Y73d9va-@mail.gmail.com>
Subject: Re: make ARM=arm menuconfig problem in mainline
From: Nobin Mathew <nobin.mathew@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding linux-arm-kernel@lists.infradead.org

Hi,

The following entry creates problem in ARM System type menu. I am
using a Fedora 12 system.

Length of bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440,
S3C2442, S3C2443, S3C2450" is the problem. How can I fix it.

config ARCH_S3C2410
       bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440,
S3C2442, S3C2443, S3C2450"
       select GENERIC_GPIO
       select ARCH_HAS_CPUFREQ
       select HAVE_CLK
       select ARCH_USES_GETTIMEOFFSET
       help
         Samsung S3C2410X CPU based systems, such as the Simtec Electronics
         BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
         the Samsung SMDK2410 development board (and derivatives).

         Note, the S3C2416 and the S3C2450 are so close that they even share
         the same SoC ID code. This means that there is no seperate machine
         directory (no arch/arm/mach-s3c2450) as the S3C2416 was first.

Thanks
Nobin
