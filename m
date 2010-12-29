Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab0L2Jyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 04:54:31 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33369 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0L2Jy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 04:54:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=lBPST4QBDmJvnTTDCB4S0oJymg72mV6EqG3WQQ8cFHjUXkvTU4Eh0IZgOIUCmOkcGL
         7SS50eAhCiuHfWqhR5471cp30XBIVRly7NWK3LSaBznXf2KtGjh43TuAJmqUItZ1kTBD
         3JVn3Vi8pP4gO75JghN6s2yKZiaV9wMx55CvQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101229130700.0ef93735.sfr@canb.auug.org.au>
References: <20101229130700.0ef93735.sfr@canb.auug.org.au>
Date: Wed, 29 Dec 2010 10:54:28 +0100
Message-ID: <AANLkTimHgKKw8eeH==YYY_Z9keewxamfOpRzLVDgKxv6@mail.gmail.com>
Subject: Re: linux-next: Tree for December 29
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 3:07 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20101228:
>

What is the recommended way in case of these "comparison" warnings?
Send to whom/where?

% grep comparison build_linux-next_next20101229.dileks.1.log
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/drivers/block/DAC960.c:5094:30:
warning: comparison between ‘DAC960_V2_IOCTL_Opcode_T’ and ‘enum
<anonymous>’
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/drivers/block/drbd/drbd_nl.c:1010:14:
warning: comparison between ‘enum drbd_ret_codes’ and ‘enum
drbd_state_ret_codes’
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/fs/pstore/platform.c:55:11:
warning: comparison of distinct pointer types lacks a cast
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/net/netfilter/nf_conntrack_netlink.c:790:11:
warning: comparison between ‘enum ctattr_tuple’ and ‘enum ctattr_type’
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/drivers/media/dvb/dvb-core/dmxdev.c:583:13:
warning: comparison between ‘enum dmx_ts_pes’ and ‘enum <anonymous>’
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/drivers/media/dvb/frontends/stv090x.c:1486:27:
warning: comparison between ‘enum stv090x_search’ and ‘enum
stv090x_delsys’
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/drivers/media/dvb/frontends/stv090x.c:1487:24:
warning: comparison between ‘enum stv090x_search’ and ‘enum
stv090x_delsys’
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c:1206:34:
warning: comparison between ‘enum sas_device_type’ and ‘enum
sas_dev_type’
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c:1209:39:
warning: comparison between ‘enum sas_device_type’ and ‘enum
sas_dev_type’
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/drivers/scsi/pm8001/pm8001_hwi.c:2934:32:
warning: comparison between ‘enum sas_device_type’ and ‘enum
sas_dev_type’
/home/sd/src/linux-2.6/linux-2.6.37-rc7/debian/build/source_i386_none/drivers/scsi/pm8001/pm8001_hwi.c:2936:37:
warning: comparison between ‘enum sas_device_type’ and ‘enum
sas_dev_type’

- Sedat -
