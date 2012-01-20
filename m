Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2ATNfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:35:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:7080 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab2ATNfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:35:50 -0500
MIME-Version: 1.0
In-Reply-To: <4F188817.3090104@zytor.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
	<CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
	<4F188817.3090104@zytor.com>
Date: Fri, 20 Jan 2012 15:35:49 +0200
Message-ID: <CALLzPKapudkuBxsF49jMAOtVpeu=hpa9SgY=WewtU6GYEm6M_Q@mail.gmail.com>
Subject: Re: dmsetup fails on latest kernel
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 11:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Here is a patch which should fix this problem.  I will run a few more
> tests and then push it with the rest of the urgent queue to Linus.
>
>        -hpa

Hi,

Yes. It solves the problem..
Do you still want straces?

- Dmitry

>
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
