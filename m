Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab1F1L1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:27:06 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45146 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab1F1L0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:23 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.33.137]
In-Reply-To: <FFF198FBBF957F4393BA834040FEFFA202EDA3@DFLE35.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <4E04F0B0.4030408@codeaurora.org> <BANLkTi=sFtwam29i4TZdi=RO7BoytTTdrw@mail.gmail.com>
 <FFF198FBBF957F4393BA834040FEFFA202EDA3@DFLE35.ent.ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 28 Jun 2011 14:26:01 +0300
Message-ID: <BANLkTiniBEuHKnmhoJEaVELpMefZ=Xk=bA@mail.gmail.com>
Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
To: "Grosen, Mark" <mgrosen@ti.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 12:22 AM, Grosen, Mark <mgrosen@ti.com> wrote:
> 2. We added a special section (resource table) that is interpreted as part
> of the loading process. The tool that generates our simple format just
> recognizes a named section (".resource_table"), so perhaps that could be
> done with the PIL ELF loader.

I hope that DT will completely replace that "resource table" section
eventually. We still need to try it out (as soon as DT materializes on
ARM/pandaboard) and see how it all fits together, but in general it
looks like DT could provide all the necessary static resource
configuration, and then we just need to expose it to the remote
processor.
