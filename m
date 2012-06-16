Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2FPGUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:20:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48941 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab2FPGUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <1339826793.9220.229.camel@pasglop>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
 <1339822897-15840-12-git-send-email-grant.likely@secretlab.ca> <1339826793.9220.229.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 16 Jun 2012 00:19:46 -0600
X-Google-Sender-Auth: J5IQsczku6v9f_Df253gIce-_3g
Message-ID: <CACxGe6vssnygze-1bKd_-gYNUzjkuLXx6aVC-a3ZSJDzYwuQew@mail.gmail.com>
Subject: Re: [PATCH 11/12] irqdomain: reorganize revmap data.
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 12:06 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2012-06-15 at 23:01 -0600, Grant Likely wrote:
>> In struct irq_domain, reorganize the revmap data in preparation for
>> unifying the linear and radix mappings.
>
> I fail to understand the patch itself... ie:

The intention was for this patch to have zero functional change; just
move around where the data was (although it looks like I missed a
hunk), and the second be the real behaviour change.  I'm fine with
merging the patches too.

g.
