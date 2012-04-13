Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2DMMce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:32:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47861 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2DMMcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:32:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120413114402.GA4969@mail.gnudd.com>
References: <cover.1334219873.git.rubini@gnudd.com>
	<5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
	<CACRpkdZCY+tbTgPyt7MWaZw93O_m28tMgaB8SbDAtJS-0VuGtw@mail.gmail.com>
	<20120413114402.GA4969@mail.gnudd.com>
Date: Fri, 13 Apr 2012 14:32:33 +0200
Message-ID: <CACRpkdY0jweVGzV76St0B-Q0fm-DQpwzPiOb5ernoLfb2aK3Lg@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 1:44 PM, Alessandro Rubini <rubini@gnudd.com> wrote:

> Besides, it's still marked as experimental, which on one side is not
> reassuring about its stability, and on the other means my whole
> chipset should depend on experimental as a consequence.

Yeah I heard that having it marked experimental was considered
harmful for adoption so we have pushed a patch removing the
experimental status. It should appear in -next tomorrow or so...

Yours,
Linus Walleij
