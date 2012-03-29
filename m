Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab2C2Iho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:37:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59963 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2C2Ihi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:37:38 -0400
MIME-Version: 1.0
In-Reply-To: <1332960747_131180@CP5-2952>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
 <1332959199-32161-6-git-send-email-djkurtz@chromium.org> <1332960747_131180@CP5-2952>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 29 Mar 2012 16:37:18 +0800
X-Google-Sender-Auth: eGoHokQ6d2j0gMgu6kqxoTsOTPE
Message-ID: <CAGS+omBWDoc2YiKPmBJ7=iEr+1DFBZp0EDCpPwP9c7FcbC4iew@mail.gmail.com>
Subject: Re: [PATCH 5/7 v6] drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 2:52 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, 29 Mar 2012 02:26:37 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
>> It is very common for an i2c device to require a small 1 or 2 byte write
>> followed by a read.  For example, when reading from an i2c EEPROM it is
>> common to write and address, offset or index followed by a reading some
>> values.
>
> Hmm, I have
>
> "gmbus1, bits 8-15: 8-bit GMBUS slave register
> This field is redundant and should not be used."
>
> Scary. :)

Perhaps INDEX ops are only available on some chipsets?
Is this something you can double check?

>
> Otherwise, the code itself looks correct and quite neatly done now.
> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
