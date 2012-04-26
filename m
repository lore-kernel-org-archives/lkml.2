Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2DZAy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:54:58 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:57299 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2DZAy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:54:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAHnt0GWABX8qOVTinmSETUHxq1Y3NhqPOKxnUgcDtyf8wjtg_g@mail.gmail.com>
References: <CAHnt0GXW-pyOUuBLB1n6qBP4WNGpET9er_HbJ29s5j5DE1xAdA@mail.gmail.com>
	<20120425222819.GF8989@google.com>
	<CAHnt0GWABX8qOVTinmSETUHxq1Y3NhqPOKxnUgcDtyf8wjtg_g@mail.gmail.com>
Date: Wed, 25 Apr 2012 17:54:57 -0700
X-Google-Sender-Auth: vkzLXkV5i2qp-TYm6ingnXx_F2c
Message-ID: <CAE9FiQUyF+yw4vNL1YziGtm9wXgGSy55nesB+BxM-gG8Zu=YtQ@mail.gmail.com>
Subject: Re: [BUG]memblock: fix overflow of array index
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 5:50 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> Thanks for the reply.   Just an educational question:  is it possible
> to set one-byte per memblock?    And what is the minimum memblock
> size?

yes. 1 byte.

>
> Even if 2G memblock is a huge number, it still seemed like a bug to me
> that there is no check on the maximum number (which is 2G) of this
> variable (assuming signed int).   Software can always purposely push
> that number up and the system can panic?

before slab is ready? how?

Thanks

Yinghai
