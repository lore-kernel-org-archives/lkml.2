Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1EDRB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:01:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46338 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580Ab1EDRB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:01:56 -0400
Subject: Re: [PATCHv2 4/4] ARM: tegra: irq: Add tegra_eoi
From: Will Deacon <will.deacon@arm.com>
To: Colin Cross <ccross@android.com>
Cc: lakml <linux-arm-kernel@lists.infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=a26_A7yAAfkQd5NSxbR+reQCZ1g@mail.gmail.com>
References: <1304284213-11950-5-git-send-email-ccross@android.com>
	 <1304288854-11011-1-git-send-email-ccross@android.com>
	 <1304414973.27863.2.camel@e102144-lin.cambridge.arm.com>
	 <BANLkTi=a26_A7yAAfkQd5NSxbR+reQCZ1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 18:01:42 +0100
Message-ID: <1304528502.1935.2.camel@craptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 19:41 +0100, Colin Cross wrote:
> What is your plan for merging the fasteoi patches?  If you are
> planning to put them in 2.6.40, can you pull these patches into your
> tree?  I don't have any other Tegra changes planned for 2.6.40, so
> they shouldn't cause conflicts later.

Ok, since Santosh would like me to take his relaxed I/O stuff for the
GIC too then I guess I can put all of this into an irq branch along with
the fasteoi changes.

Russell - would you be happy pulling this from me if I put it together?

Cheers,

Will

