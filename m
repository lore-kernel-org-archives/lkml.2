Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1HJDcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 23:32:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab1HJDcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 23:32:07 -0400
Message-ID: <4E41FBAE.4050202@redhat.com>
Date: Wed, 10 Aug 2011 11:31:58 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: add missing header file <linuc/types.h>
References: <1312788155-8451-1-git-send-email-amwang@redhat.com> <CADnq5_O=69Q2HQCoQ0XSXCi85LYzCcx7wbqGH4UmD89hmiVHfA@mail.gmail.com>
In-Reply-To: <CADnq5_O=69Q2HQCoQ0XSXCi85LYzCcx7wbqGH4UmD89hmiVHfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年08月09日 21:32, Alex Deucher 写道:
> On Mon, Aug 8, 2011 at 3:22 AM, Amerigo Wang<amwang@redhat.com>  wrote:
>> This patch fixes the following 'make headers_check' errors:
>>
>> linux-2.6/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include<linux/types.h>
>> linux-2.6/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include<linux/types.h>
>> linux-2.6/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include<linux/types.h>
>> linux-2.6/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include<linux/types.h>
>> linux-2.6/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include<linux/types.h>
>>
>
> These files are shared with BSD, and they get the linux/types.h from drm.h.
>

Thanks, then these warnings should be bogus.
