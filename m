Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0IVMKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 08:10:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59881 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab0IVMKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 08:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Tsd8vosqn7/xw5B2oA+nEH8093SK6bi1OZeJuujYfv/ev+PPgH5dU3wgsQxD8Wq4qj
         k/FLBpP1jg2PBBThahqV6f68ouPKVzD4Dh3zVqEP/tUDXcpfXFOzwi/Gi/VaMw/wlOnJ
         GBm1ZtJOfuc+eOGWT6qD5Z8ibjU4/bmYdsGrc=
From: Diego Calleja <diegocg@gmail.com>
Reply-To: diegocg@gmail.com
To: Juan PC <piernas@ditec.um.es>
Subject: Re: CFQ I/O scheduler better than AS?
Date: Wed, 22 Sep 2010 14:10:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-00040-gbfa88ea; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1285152908.10774.306.camel@albahaca.inf.um.es>
In-Reply-To: <1285152908.10774.306.camel@albahaca.inf.um.es>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009221410.17056.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Miércoles, 22 de Septiembre de 2010 12:55:08 Juan PC escribió:
> Hi:
> 
> I am sure that, for most people, the clear answer is "yes" (after all,
> CFQ is the default I/O scheduler in Linux), but we are having serious
> difficulties to find a benchmark which shows that CFQ is undoubtedly
> better than AS.

The AS io scheduler was removed in 2.6.33 (7 months ago, in commit 
492af6350a5ccf087e4964104a276ed358811458), so you must be running
benchmarks in old kernels. The CFQ scheduler used in recent kernels
should have good performance (if it doesn't, you probably should
write a bug report ccing jens.axboe@oracle.com)

Saludos ;)
