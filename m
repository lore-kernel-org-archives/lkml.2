Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0FKFum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:50:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34402 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab0FKFul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:50:41 -0400
Message-ID: <4C11CEAA.5020703@zytor.com>
Date: Thu, 10 Jun 2010 22:50:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
       Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH 1/2] vmlinux.lds.h: allow people to set a smaller rootfs
 	alignment
References: <1275761686-4996-1-git-send-email-vapier@gentoo.org> 	<1276068030_13535@mail4.comsite.net> <AANLkTin_MR82jafZkkzfv33dO6DqyFnHUiU4g6luXB_0@mail.gmail.com>
In-Reply-To: <AANLkTin_MR82jafZkkzfv33dO6DqyFnHUiU4g6luXB_0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 12:42 AM, Mike Frysinger wrote:
> 
> i have no problem changing the default to 4 since it works fine on
> Blackfin systems.  your analysis of the source alignment also seems
> reasonable ... i assume that the 8 byte fields in the source cpio
> arent referenced directly, otherwise it'd cause problems on 64bit
> systems that require 64bit values to be naturally aligned.
> 
> beyond that, i dont see why any larger alignment values would be
> required since this source archive isnt executed directly.  it gets
> expanded into a ramfs and then freed with the rest of the init stuff.
> 

We have talked for a long time about incrementally freeing the initramfs
as it is decoded, which might help systems which are using most of their
memory for an initramfs image...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

