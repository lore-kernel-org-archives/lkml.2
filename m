Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab1FFVdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:33:45 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:40855 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1FFVdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:33:44 -0400
MIME-Version: 1.0
In-Reply-To: <20110606205716.GC27341@opensource.wolfsonmicro.com>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <nack-locate@mdm.bga.com> <20110603104217.GA4777@opensource.wolfsonmicro.com>
 <locate-from-more@mdm.bga.com> <20110603150636.GA9492@opensource.wolfsonmicro.com>
 <alpine.LFD.2.02.1106031823310.3078@ionos> <irq-locate-ack@mdm.bga.com>
 <20110604095138.GA708@opensource.wolfsonmicro.com> <BANLkTi=MTWcKz0jd_p_n3Yz3DJQp4rs1Sg@mail.gmail.com>
 <20110606205716.GC27341@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 15:33:24 -0600
X-Google-Sender-Auth: ypF9a8T4aP-aBb2F5SK1rly4P98
Message-ID: <BANLkTikzpNy-oVC0SYYAcsbxsWp6W7+wGA@mail.gmail.com>
Subject: Re: genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Milton Miller <miltonm@bga.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 2:57 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jun 06, 2011 at 01:42:33PM -0600, Grant Likely wrote:
>> On Sat, Jun 4, 2011 at 3:51 AM, Mark Brown
>
>> > I'm not really sure what an IRQ domain is (the patch series you pointed
>> > at before does rather appear to assume one knows already)
>
>> (obviously I need to write some documentation).  irq_domains is some
>> infrastructure to make managing a range of irq numbers easier, and
>> also to handle the mapping of hw irq numbers to linux irq numbers.
>
> Hrm, in that case it sounds rather like a lot of interrupt controllers
> ought to be making themselves IRQ domains?

yup, and I'll probably craft patches for RFC to do exactly that when
I've got irq_domains sorted out.

g.
