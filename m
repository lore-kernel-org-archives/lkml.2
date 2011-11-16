Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab1KPRzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:55:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58096 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1KPRzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:55:08 -0500
MIME-Version: 1.0
In-Reply-To: <4EC32716.8020202@linux.intel.com>
References: <20111114232912.GA14717@www.outflux.net>
	<4EC32716.8020202@linux.intel.com>
Date: Wed, 16 Nov 2011 09:55:07 -0800
X-Google-Sender-Auth: GM-u8uyIrbex5k9wMltBkqfDEes
Message-ID: <CAGXu5j+hxaoz4=vmcJfsjbma09QBmv3ErQG+CZkV1mFGi=K++w@mail.gmail.com>
Subject: Re: [PATCH] pstore: pass reason to backend write callback
From: Kees Cook <keescook@chromium.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 6:59 PM, Chen Gong <gong.chen@linux.intel.com> wrote:
> 于 2011/11/15 7:29, Kees Cook 写道:
>> This allows a backend to filter on the dmesg reason as well as the pstore
>> reason. When ramoops is switched to pstore, this is needed since it has
>> no interest in storing non-crash dmesg details.
> We ever talked about it here: https://lkml.org/lkml/2011/9/20/468.
> Matthew's patch is good enough if pstore_write can be cleaned.

Ah, thanks for the URL. Yeah, it looks like it would be sane to just
remove pstore_write completely. I will send an updated patch.

Thanks!

-Kees

-- 
Kees Cook
ChromeOS Security
