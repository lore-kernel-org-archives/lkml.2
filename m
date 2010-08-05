Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497Ab0HEWBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:01:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:58232 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab0HEWBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:01:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=XU1CkRpI7FxsCTMTFvkeA3ZerlJtz9BL8lNPrVF2C5PLu4/CmsuSQ5J3EhPTOZAGy
	WPf101um5+vKrZ7ZaMFCQ==
MIME-Version: 1.0
In-Reply-To: <1281044755.30969.8.camel@c-dwalke-linux.qualcomm.com>
References: <AANLkTi=dcQrik=+5xfwbNo_w7WkTOKZiKAFYFhwzbS=_@mail.gmail.com>
	<1281044755.30969.8.camel@c-dwalke-linux.qualcomm.com>
Date: Thu, 5 Aug 2010 15:01:43 -0700
Message-ID: <AANLkTimZYveOZLoDS82z0nosAHa21ChHCK1GpophEQ1P@mail.gmail.com>
Subject: Re: [GIT PULL] Initial Tegra ARM support
From: Erik Gilling <konkers@google.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If these changes went through Russell's tree there would be
dependancies on arch/arm/mach-tegra/(Makefile|Kconfig) in
arch/arm/(Makefile|Kconfig) breaking Russell's tree until it was
merged with the tegra tree.  That sounds wrong to me.  Additionally
these patches have received review on LAKML including some by Russell
and nothing was mentioned about this being a problem.

There is a conflict on these against linux/master.  I'm rebasing now for Linus.

-Erik

On Thu, Aug 5, 2010 at 2:45 PM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Thu, 2010-08-05 at 14:10 -0700, Erik Gilling wrote:
>>  arch/arm/Kconfig                               |   25 +-
>>  arch/arm/Makefile                              |    1 +
>
> In the future could you please send changes to arch/arm/Kconfig and
> arch/arm/Makefile to Russell .. That way there's no chance for conflicts
> with other -next trees.
>
> Daniel
> --
> Sent by an consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
>
