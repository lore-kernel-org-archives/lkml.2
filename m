Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965288Ab1GMLWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:22:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33944 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915Ab1GMLWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <4E1D6396.1070200@suse.cz>
References: <alpine.DEB.2.01.1107040242180.9183@trent.utfs.org>
	<1310470780-12330-1-git-send-email-mmarek@suse.cz>
	<CAM_iQpWfSFPcvDJCDwS9ADCEvw-6A3wyUh+kkhgqHOi2Zx_eSg@mail.gmail.com>
	<4E1D6396.1070200@suse.cz>
Date: Wed, 13 Jul 2011 19:22:18 +0800
Message-ID: <CAM_iQpUoLwar3wYUe-3i5tgSB4e9HF__QKSht2yxVYP_MmUqyQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Do not write to builddir in modules_install
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 5:21 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 13.7.2011 03:05, Américo Wang wrote:
>>
>> On Tue, Jul 12, 2011 at 7:39 PM, Michal Marek<mmarek@suse.cz>  wrote:
>>>
>>> Let depmod.sh create a temporary directory in /tmp instead of writing to
>>> the build directory as root. The mktemp utility should be available on
>>> any recent system (and there is already scripts/gen_initramfs_list.sh
>>> relying on it).
>>>
>>
>> Hmm, why not use $objtree/.tmp_depmod?
>
> That's how it was done before and it's broken. make modules_install is
> usually ran as root and there is no guarantee that root has write access to
> the build directory (it can be on nfs).

Hmm, this is reasonable. Then I am fine with this patch.

Thanks for explanation!
