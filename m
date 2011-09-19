Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1ISPPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 11:15:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2153 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1ISPPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 11:15:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6473"; a="119617390"
Date: Mon, 19 Sep 2011 10:15:32 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Dongdong Deng <libfetion@gmail.com>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-arch@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 31/36] Hexagon: kgdb support files
Message-ID: <20110919151532.GA6830@codeaurora.org>
References: <e97c6e$3hno1n@wolverine02.qualcomm.com>
 <CAGn38=0herzUuFyq7-4irgi8Myq0tibz0FGLiZY0GRq8iiO5kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGn38=0herzUuFyq7-4irgi8Myq0tibz0FGLiZY0GRq8iiO5kg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 05:46:09PM +0800, Dongdong Deng wrote:
> On Thu, Sep 15, 2011 at 2:19 AM, Richard Kuo <rkuo@codeaurora.org> wrote:
> > +#if 0
> > +       ret = kgdb_handle_exception(args->trapnr & 0xff, args->signr, args->err,
> > +                                   regs);
> > +       if (ret)
> > +               return NOTIFY_DONE;
> > +#endif
> 
> Hmm,  the key code of invoking kgdb_core was disabled by "#if 0".

The Hexagon kgdb implementation is incomplete; I work on it as time
permits and urgency requires.  I know from direct experience that,
for kernel bringup and stress testing on new platforms, that kdb is 
invaluable, being infinitely easier to use than any hardware debugger.
(cheaper, too)

This world could use a really cheap, easy-to-setup jtag debugger.

-- Linas

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
