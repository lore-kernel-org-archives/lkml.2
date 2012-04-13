Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2DMQeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:34:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58466 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2DMQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:34:07 -0400
MIME-Version: 1.0
In-Reply-To: <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
References: <cover.1334219873.git.rubini@gnudd.com>
	<5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
Date: Fri, 13 Apr 2012 18:34:06 +0200
Message-ID: <CACRpkdahP=t_JPBKrtR2KhMYNqVxCJMoySXCaQobx=LrpLvSOw@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, sameo@linux.intel.com,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 10:48 AM, Alessandro Rubini <rubini@gnudd.com> wrote:

> This introduces 128 gpio bits (for each PCI device installed) with
> working interrupt support.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Alan Cox <alan@linux.intel.com>

Grant, I prefer that you make a decision on this driver since I have
a conflict of interest (it's written for ST).

Yours,
Linus Walleij
