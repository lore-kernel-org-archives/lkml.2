Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196Ab2C2Tvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:51:41 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39664 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2C2Tvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <1333044612.15602.4.camel@joe2Laptop>
References: <20120329164842.GE28941@google.com>
	<1333044612.15602.4.camel@joe2Laptop>
Date: Thu, 29 Mar 2012 12:51:34 -0700
X-Google-Sender-Auth: M0G3uvXLnGlNU8JpJZr01gKT9TI
Message-ID: <CAOS58YOWA9U3Esb2535v_iivPaXeFYYS3nWd2KKF1=MsfZ0Piw@mail.gmail.com>
Subject: Re: [PATCH] percpu: use KERN_CONT in pcpu_dump_alloc_info()
From: Tejun Heo <tj@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Joe.

On Thu, Mar 29, 2012 at 11:10 AM, Joe Perches <joe@perches.com> wrote:
> Perhaps it's better to try to print lines
> in fewer printks?  Maybe use a line buffer?

What practical difference would that make?

> The first line could be newline terminated.
> "if (alloc)" tests for the individual newlines could be added.
> Why aren't the group widths on separate lines?
> All of the cpu_widths are on the same line as the parent group
> even if that exceeds apl.  Is that what's desired?

I frankly don't remember. I wanted something easy on the eye during
the development to verify the config results and it worked well enough
for me. If you can simplify it, please go ahead and submit a patch.

Thanks.

-- 
tejun
