Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2AXErS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 23:47:18 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34841 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab2AXErQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 23:47:16 -0500
MIME-Version: 1.0
In-Reply-To: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
Date: Mon, 23 Jan 2012 20:47:14 -0800
Message-ID: <CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 17:36, Norbert Preining <preining@logic.at> wrote:
> Dear all,
>
> (please cc)
>
> long time ago we had a long discussion about iwlagn regressions in 3.1.0
> Up to 3.2 I still have regular problems on the university network
> with stuck iwl driver not even realizing that nothing goes out or in.
>
> Today I switched to 3.3-rc1 to see it is getting even worse, now on my
> home network I get stuck queue and no connection:
>

Can you please run with debug flags 0x80000000 ?
We will probably need to enable TX_REPLY too: 0xC0000000 but this one
is noisy, so let's begin the 0x80000000
