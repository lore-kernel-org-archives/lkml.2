Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab0FBQYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:24:31 -0400
Received: from smtp-out.google.com ([74.125.121.35]:13776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab0FBQYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:24:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:from:date:
	x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=wVQZPk87vL9BYx6zN88EzMcO5Vx++3ZGwtyYJUHJ1tOuuUFimKgF1qXAlk56YKKrp
	FTq3dV4BmIs41/xCbsvqA==
MIME-Version: 1.0
In-Reply-To: <4C068355.9070000@zytor.com>
References: <20100602151602.GA3656@google.com> <4C068355.9070000@zytor.com>
From: Bill Richardson <wfrichar@chromium.org>
Date: Wed, 2 Jun 2010 09:24:04 -0700
X-Google-Sender-Auth: Nzj7ubqp6CjbE7th8p9LBiVSuCw
Message-ID: <AANLkTinTS9q_mYcC2Q6HKHJt_XeLc11j-vc7Iu9HKZpQ@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Allow empty e820 map if EFI map will be provided 
	later.
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
       akpm@linux-foundation.org, fweisbec@gmail.com, yinghai@kernel.org,
       pavel@ucw.cz, shane.wang@intel.com, linux-kernel@vger.kernel.org,
       olofj@chromium.org, msb@chromium.org, drewry@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 9:14 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> No!  Bloody **** hell no!

Heh. Well, that answers that.


> This was settled in 2007 -- it is the boot loaders duty to provide a memory map.  The fact that we allowed a
> hack in to let the kernel itself add additional ranges from EFI has proven to be an utter mistake, and this is
> yet another example of it.

Ah. With that hint, I've now found some of the original discussion.
Sorry I missed it before. Having dealt with EFI for some weeks now, I
can't say I find your reaction overstated.

Thanks for the quick response.

Bill
