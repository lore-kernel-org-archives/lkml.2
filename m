Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab2CFKdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:33:49 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:60627 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758838Ab2CFKdr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:33:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of sumit.semwal@ti.com designates 10.182.36.106 as permitted sender) smtp.mail=sumit.semwal@ti.com
MIME-Version: 1.0
In-Reply-To: <CAKMK7uHnNMytknBO2y=ioPXJ9tZpy99ntGP=iPVzyjvXmTmj9g@mail.gmail.com>
References: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
 <1330616161-1937-3-git-send-email-daniel.vetter@ffwll.ch> <CAF6AEGtynLeNds9DFjr6G08UMWMBQn8tn10UgFTNz9P7SwQuUQ@mail.gmail.com>
 <CAKMK7uHnNMytknBO2y=ioPXJ9tZpy99ntGP=iPVzyjvXmTmj9g@mail.gmail.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Tue, 6 Mar 2012 16:03:26 +0530
Message-ID: <CAB2ybb_XiuW=5GeOepGjE8yNtV5rTxDfE09Ti8uaZnrsy9j1CQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] dma-buf: add support for kernel cpu access
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robdclark@gmail.com>, linaro-mm-sig@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,
On Tue, Mar 6, 2012 at 12:27 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Fri, Mar 2, 2012 at 23:24, Rob Clark <robdclark@gmail.com> wrote:
>> Perhaps we should check somewhere for required dmabuf ops fxns (like
>> kmap_atomic here), rather than just calling unconditionally what might
>> be a null ptr.  At least put it in the WARN_ON(), but it might be
>> nicer to catch a missing required fxns at export time, rather than
>> waiting for an importer to try and call it.  Less likely that way, for
>> newly added required functions go unnoticed.
>>
>> (same comment applies below for the non-atomic variant.. and possibly
>> some other existing dmabuf ops)
>
> Agreed, I'll rework the patch to do that when rebasing onto Sumit's latest tree.
In addition, you'd not need to check for !dmabuf->ops since the export
should already catch it.

As I sent in the other mail a while back, could you please rebase on
for-next at git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git

Best regards,
~Sumit.
> -Daniel
> --
