Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0GMNKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 09:10:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab0GMNKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 09:10:52 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CFQ: Don't store left slice when slice used up or for a idle workload
References: <4C3BCDA1.5040007@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 13 Jul 2010 09:10:37 -0400
In-Reply-To: <4C3BCDA1.5040007@cn.fujitsu.com> (Gui Jianfeng's message of
	"Tue, 13 Jul 2010 10:21:21 +0800")
Message-ID: <x49r5j7plwy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gui Jianfeng <guijianfeng@cn.fujitsu.com> writes:

> It doesn't make sence to store left time slice for an idle workload
> or for the cfqq that uses up its slice.

Did you actually observe any problems?  As I understand it, if you
overrun your slice you get a negative offset, so I think we want to keep
that.

Cheers,
Jeff
