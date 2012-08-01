Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2HAVcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 17:32:21 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64437 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2HAVcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:32:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120801205640.GN5470@ics.muni.cz>
References: <20120801133835.GH5470@ics.muni.cz>
	<CAG4TOxONLJnBaY7N5x7Kfi+dwCb507QPqX9s_Wuef10+RzM=AQ@mail.gmail.com>
	<CAE9FiQUSFeBpGaFByOfENUa8qg7t89WTiUann8=4ezT7s2qmzw@mail.gmail.com>
	<20120801205640.GN5470@ics.muni.cz>
Date: Wed, 1 Aug 2012 14:32:17 -0700
X-Google-Sender-Auth: v9lC-aMT-6MaVovLYv9jA_Fh2As
Message-ID: <CAE9FiQWmgyirjjCwn54PkAsfvWxZSY5RhRVDkhhbK7E0NPzqaw@mail.gmail.com>
Subject: Re: mellanox mlx4_core and SR-IOV
From: Yinghai Lu <yinghai@kernel.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Roland Dreier <roland@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 1:56 PM, Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
> On Wed, Aug 01, 2012 at 11:29:02AM -0700, Yinghai Lu wrote:
>> iov bar is not assigned by BIOS, and kernel can not find range for it too.
>>
>> Lukas, can you post whole boot log with PCI_DEBUG enabled? That will
>> tell exact why kernel does not assign them.
>>
>> Recent kernel from 3.4... should enable realloc when SRIOV bar is not assigned.
>
> sorry for confusing, PCI_DEBUG does not break mlx driver, it is reallocation
> code that results:
> [    3.555008] mlx4_core 0000:02:00.0: Missing UAR, aborting.

yes, i knew that.

one patch in my for-pci-next should address that.

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=patch;h=fcce563f868e296f46a2eeaa88d6959bcee26a2d

Thanks

Yinghai
