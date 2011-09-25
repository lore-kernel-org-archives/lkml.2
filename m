Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab1IYGjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 02:39:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39702 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1IYGjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 02:39:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110908020235.GA582@animx.eu.org>
References: <20110908015105.GA31062@animx.eu.org>
	<20110908020235.GA582@animx.eu.org>
Date: Sun, 25 Sep 2011 07:39:08 +0100
Message-ID: <CAPM=9tyTYAHGMihPskc6gTtPxdn4PXBuEU93TJnPDX8=9pvE=A@mail.gmail.com>
Subject: Re: radeon KMS (R100) on dell inspiron 5100 blank screen
From: Dave Airlie <airlied@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Here's the relevent dmesg:
>>
>> [drm] radeon defaulting to kernel modesetting.
>> [drm] radeon kernel modesetting enabled.
>> [drm] initializing kernel modesetting (RV200 0x1002:0x4C57).
>> [drm] register mmio base: 0xFCFF0000
>> [drm] register mmio size: 65536
>> radeon 0000:01:00.0: Invalid ROM contents
>> radeon 0000:01:00.0: Invalid ROM contents
>> [drm:radeon_get_bios] *ERROR* Unable to locate a BIOS ROM

^^ this is  strange on an x86 machine, we should always be able to find a BIOS,

The only thing I can think off is the BIOS is corrupted somehow,

if you run nomodeset can you get an Xorg.0.log?

Dave.
