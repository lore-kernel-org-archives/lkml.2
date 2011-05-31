Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab1EaVcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:32:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab1EaVcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:32:12 -0400
Message-ID: <4DE55E5A.5050206@redhat.com>
Date: Tue, 31 May 2011 17:32:10 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 09/35] drivers/gpio changes for SMBIOS and System
 Firmware
References: <20110531155140.3507.6599.sendpatchset@prarit.bos.redhat.com> <BANLkTi=eRoTKNsBxp483kr1ZFh=MQKi2kQ@mail.gmail.com>
In-Reply-To: <BANLkTi=eRoTKNsBxp483kr1ZFh=MQKi2kQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/31/2011 03:17 PM, Grant Likely wrote:
> Hi Prarit
>
> I could use some background on why the mod_devicetable.h include is
> being removed from basic_mmio_gpio (need a commit description).  

Grant, this was part of a cleanup of the dmi* code.  Currently DMI*
(which have now been changed to SYSFW*) definitions are in
mod_devicetable.h.  AFAICT, mod_devicetable.h is not needed in the gpio
file.

> Also,
> any reason why this change isn't squashed in the patch that
> necessitates it?
>   

Purely organization of the patchset -- the SYSFW & SMBIOS code touches
close to 180 different files.  I decided that a directory-by-directory
breakout of the drivers/* patches was the best way to go.

P.

> g.
>
> On Tue, May 31, 2011 at 9:51 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>   
>>     
>
>
>   
