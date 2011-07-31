Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1GaJJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 05:09:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59600 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1GaJJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 05:09:21 -0400
Date: Sun, 31 Jul 2011 10:09:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.kumar@st.com>, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, bhupesh.sharma@st.com, shiraz.hashim@st.com,
        vinod.koul@intel.com, linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/18] dmaengine/amba-pl08x: max_bytes_per_lli is
	TRANSFER_SIZE * src_width (not MIN(width))
Message-ID: <20110731090903.GB30888@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <5521ee74eef41cf26a9f1ece6dadd32cca529cce.1311936524.git.viresh.kumar@st.com> <CAKnu2MpUj9JDDg8psPf5WaGGFSZGmPcmtiujKiFzcHM71RqLKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKnu2MpUj9JDDg8psPf5WaGGFSZGmPcmtiujKiFzcHM71RqLKQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 02:27:38AM +0200, Linus Walleij wrote:
> 2011/7/29 Viresh Kumar <viresh.kumar@st.com>:
> 
> > max_bytes_per_lli = bd.srcbus.buswidth * PL080_CONTROL_TRANSFER_SIZE_MASK;
> > This is confirmed by ARM support guys.
> 
> Great and THANKS for your tiresome research in ironing out the ambiguities
> in the manuals.

The manual isn't that bad.  The code from ARM though is, and raises lots
of "why are they doing that?  oh, they must know better than the docs"
type questions.  Obviously they don't!
