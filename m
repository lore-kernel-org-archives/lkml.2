Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1LSEbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:31:19 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:53646 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135Ab1LSEbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:31:17 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V1 Resend 0/3] dmaengine: Allow controller drivers to set channel ids
Date: Mon, 19 Dec 2011 10:00:57 +0530
Message-ID: <cover.1324268691.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Probably you missed this patchset earlier, so resending it again.

Currently value of chan_id field is updated by dmaengine.c while the dma device
is registered. In some cases the controller driver may need to assign channel
numbers by itself. This patchset introduces changes to do it.

Viresh Kumar (3):
  dmaengine: Allow controller drivers to set channel ids
  dmaengine/dw_dmac: Set channel id's in controller driver
  dmaengine/dw_dmac: Don't use magic number for total number of
    channels

 drivers/dma/dmaengine.c   |    7 ++++++-
 drivers/dma/dw_dmac.c     |    4 +++-
 include/linux/dmaengine.h |    5 +++++
 3 files changed, 14 insertions(+), 2 deletions(-)

-- 
1.7.8.110.g4cb5d

