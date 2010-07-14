Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0GNAmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:42:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62866 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab0GNAmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:42:13 -0400
Message-ID: <4C3D0762.2060807@cn.fujitsu.com>
Date: Wed, 14 Jul 2010 08:40:02 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CFQ: Don't store left slice when slice used up or for
 a idle workload
References: <4C3BCDA1.5040007@cn.fujitsu.com> <x49r5j7plwy.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49r5j7plwy.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
> Gui Jianfeng <guijianfeng@cn.fujitsu.com> writes:
> 
>> It doesn't make sence to store left time slice for an idle workload
>> or for the cfqq that uses up its slice.
> 
> Did you actually observe any problems?  As I understand it, if you
> overrun your slice you get a negative offset, so I think we want to keep
> that.

Hi Jeff

If that's the case, do we also need to store the negative offset when slice
used up in cfq_select_queue() and cfq_idle_slice_timer()?

Thanks
Gui

> 
> Cheers,
> Jeff
> 
> 
