Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0DOIOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:14:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53153 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0DOIO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ia1Z+RlQpB5R5fET6GU/TA9D1LRH5sDQsgiJmliB4eOI/ASJ/Fn4U6KV+SATWF7Nep
         Macp7BX3OdZ2wmCFXp0kTTviT3agqZQ/PBeB0/j5MDWVOx2Vypd2Uzlbzf9XfR/VuG0i
         FzQIZC2X+/tL6eZT4CvjhD/Ike5hi5G4xN9E4=
MIME-Version: 1.0
In-Reply-To: <x2nc27429821004142322i3ce6756dib9c1a3f86000c5f5@mail.gmail.com>
References: <x2nc27429821004142322i3ce6756dib9c1a3f86000c5f5@mail.gmail.com>
Date: Thu, 15 Apr 2010 13:44:28 +0530
Message-ID: <s2u887f81cc1004150114l96254dfcmf5590d24f8418d00@mail.gmail.com>
Subject: Re: [Question] integrating KDB with linux kernel
From: anil kumar <m.anilkumar80@gmail.com>
To: santosh <santosh.iitg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Looks like system is running in graphical mode. First go to terminal
of system (e.g using alt+ctrl+1)  and then invoke kdb

Regards,
Anil




On Thu, Apr 15, 2010 at 11:52 AM, santosh <santosh.iitg@gmail.com> wrote:
> How to integrate KDB with linux-kernel ??
>
> What I did was as follow:
>
> 1.   Used  linux-2.6.21.7.tar.gz
>
>  2.  Downloaded corresponding kdb  from "oss.sgi" site
>
>    kdb-v4.4-2.6.21-common-3.bz2
>
>
>   kdb-v4.4-2.6.21-i386-3.bz2
>
>
>
> 3.  build the kernel by enabling CONFIG_KDB and CONFIG_FRAME_POINTER as
> described in "oss.sgi"
>
> 4.  installed the kernel and rebooted the system
>
> 5. When the system comes up, I check the kdb status
>
> cat /proc/sys/kernel/kdb
> // screen :
> 1
>
> I logged in as root then invoke the kdb by press Pause on keyboard, but the
> kdb
> don't invoke. The system hangs  and two leds Caps Lock and Scroll Lock are
> blinking. I had to do hard reboot .
>
> .
>
> please help me to fix this problem
>
> regards
> santosh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
