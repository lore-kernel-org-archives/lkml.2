Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2BASL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:11:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60218 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab2BASL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:11:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120201141705.GF9587@linutronix.de>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <1327700179-17454-23-git-send-email-grant.likely@secretlab.ca>
 <20120128164405.GA20763@linutronix.de> <20120130195842.GT28397@ponder.secretlab.ca>
 <20120201141705.GF9587@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 1 Feb 2012 11:06:04 -0700
X-Google-Sender-Auth: YIjIcRzNjtfM3wNDg_mld_D1YVo
Message-ID: <CACxGe6vZxWXUG-WJFWDaoH3+PYBGWOXb291_jn9TdjrSF=p_JQ@mail.gmail.com>
Subject: Re: [PATCH v3 22/25] irq_domain/x86: Convert x86 (embedded) to use
 common irq_domain
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 7:17 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> * Grant Likely | 2012-01-30 12:58:42 [-0700]:
>
>>Ugh.  This isn't easy.  The legacy mapping really needs all the
>
> Feel free to merge this patch. I don't have the time to look at this now
> so I take a look at the ioapic later.

There's no rush here.  I can leave it as-is with IRQ_DOMAIN turned off
for x86 for now.

g.
