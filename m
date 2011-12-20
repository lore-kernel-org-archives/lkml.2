Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1LTJkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:40:31 -0500
Received: from mga12.intel.com ([143.182.124.36]:39634 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751982Ab1LTJk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:40:27 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1324268691.git.viresh.kumar@st.com>
References: <cover.1324268691.git.viresh.kumar@st.com>
Date: Tue, 20 Dec 2011 01:40:24 -0800
Message-ID: <CABE8wwuS9f0-5ZFAV3EiYqaw=LoLLqTB=dJkfObZm2LXdEo=+A@mail.gmail.com>
Subject: Re: [PATCH V1 Resend 0/3] dmaengine: Allow controller drivers to set
 channel ids
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 8:30 PM, Viresh Kumar <viresh.kumar@st.com> wrote:
> Hi Dan,
>
> Probably you missed this patchset earlier, so resending it again.
>
> Currently value of chan_id field is updated by dmaengine.c while the dma device
> is registered. In some cases the controller driver may need to assign channel
> numbers by itself. This patchset introduces changes to do it.

Didn't we already go through this discussion once?

Here is the old thread: http://marc.info/?t=131122111000001&r=2&w=2

The chan_id is really only a sysfs detail, and for the same reasons
that scsi_host adapters don't pick their own host number neither
should dma channels.

The driver can set a channel id in its private channel struct right?

--
Dan
