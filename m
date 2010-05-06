Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0EFHfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:35:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55069 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab0EFHfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I/PYQUHKBjQjiaiqSSW8WyXtEYXDDuBW/zT+z6i8X9OlwMEnANBPbSwwLF9by79btH
         ZtUhTN/vip3sN+nYYTV0u7jBg9U5u2AUh1tyJHcIwh+BDwg7tAMMIw7D/ZyJoDrI8NWZ
         HEnFT9Zx/rg3wjV2y3ubG29U7jeIWrpj8sY/k=
Message-ID: <4BE27123.6070501@gmail.com>
Date: Thu, 06 May 2010 09:34:59 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefan Weinhuber <wein@linux.vnet.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stefan Weinhuber <wein@de.ibm.com>,
       Horst Hummel <Horst.Hummel@de.ibm.com>,
       Stefan Haberland <stefan.haberland@de.ibm.com>,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: deadline ALWAYS default for dasd devices(s390) ?
References: <4BD58848.8090205@gmail.com> <20100505061620.GA2381@osiris.boeblingen.de.ibm.com> <4BE123B1.1050500@linux.vnet.ibm.com>
In-Reply-To: <4BE123B1.1050500@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 09:52 AM, Stefan Weinhuber wrote:

hi,

> At the time this change was made we had the problem that the
> default scheduler chosen by the distributions resulted in
> bad performance for DASD devices.

Have you done recently new cfq vs. deadline tests, in z/VM
and LPAR ?

> I agree that hard coding this choice into the driver is not pretty,
> but it is pragmatic. 

It's awful. Easier and simpler from user space: /sys/block/dasdX/queue/scheduler

> Some generic mechanism for setting driver specific
> defaults would be nicer, but I doubt that many other drivers would
> actually benefit from such an interface.

see s390-tools-1.8.4/etc/udev/rules.d/60-readahead.rules
That's the way to do it.

-thanks-

-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
