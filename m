Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2FPGVC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:21:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52407 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab2FPGVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:21:00 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vssnygze-1bKd_-gYNUzjkuLXx6aVC-a3ZSJDzYwuQew@mail.gmail.com>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
 <1339822897-15840-12-git-send-email-grant.likely@secretlab.ca>
 <1339826793.9220.229.camel@pasglop> <CACxGe6vssnygze-1bKd_-gYNUzjkuLXx6aVC-a3ZSJDzYwuQew@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 16 Jun 2012 00:20:40 -0600
X-Google-Sender-Auth: Q6KIIrYrE11-k12M0iQFvaY5PMs
Message-ID: <CACxGe6sH1SHGJ1JHLESpZAqppsODxi10OXNi=8UbvORjd5bK5g@mail.gmail.com>
Subject: Re: [PATCH 11/12] irqdomain: reorganize revmap data.
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 12:19 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Sat, Jun 16, 2012 at 12:06 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> On Fri, 2012-06-15 at 23:01 -0600, Grant Likely wrote:
>>> In struct irq_domain, reorganize the revmap data in preparation for
>>> unifying the linear and radix mappings.
>>
>> I fail to understand the patch itself... ie:
>
> The intention was for this patch to have zero functional change; just
> move around where the data was (although it looks like I missed a
> hunk), and the second be the real behaviour change.  I'm fine with
> merging the patches too.

Oh, and thanks for the quick review!  :-)

g.
