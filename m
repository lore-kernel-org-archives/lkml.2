Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603Ab2C3J41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:56:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47004 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181Ab2C3J4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:56:20 -0400
Message-ID: <1333101375.2833.34.camel@dabdike>
Subject: Re: [PATCH 0/4] block: move sd_format_disk_name() into block core
 as disk_name_format()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Date: Fri, 30 Mar 2012 10:56:15 +0100
In-Reply-To: <4F7581D4.4040301@cn.fujitsu.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 17:50 +0800, Ren Mingxin wrote:
> 
> This patch series renames "sd_format_disk_name()" to
> "disk_name_format()" and moves it into block core. So
> that who needs formatting disk name can use it, instead
> of duplicating these similar help functions.
> 
> Ren Mingxin (4):
>    block: add function disk_name_format() into block core
>    scsi: replace sd_format_disk_name() to disk_name_format()

These two should be a single patch so it makes it obvious to anyone
looking through the change sets that the code is merely being moved.

Other than that, everything looks fine to me.

James


