Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1DPQfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:35:18 -0400
Received: from 8bytes.org ([88.198.83.132]:33371 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab1DPQfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:35:11 -0400
Date: Sat, 16 Apr 2011 18:35:10 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        alexandre.f.demers@gmail.com
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110416163509.GS18463@8bytes.org>
References: <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110415131152.GJ18463@8bytes.org> <20110415131650.GB18660@elte.hu> <20110415154604.GN18463@8bytes.org> <BANLkTim23SQiyb4R+QA7=fpPZrnQw9_PRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim23SQiyb4R+QA7=fpPZrnQw9_PRQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 12:11:28PM -0400, Jerome Glisse wrote:
> Do you also got the write if you load radeon with radeon.no_wb=1 ?
> I think at this address it's the wb page, or maybe the cp as wb likely
> take only one page

radeon.no_wb=1 makes no difference. The box still reboots.

	Joerg

