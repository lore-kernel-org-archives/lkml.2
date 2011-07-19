Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1GSJCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:02:53 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:57063 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab1GSJCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:02:52 -0400
Message-ID: <4E254067.1060408@st.com>
Date: Tue, 19 Jul 2011 13:59:27 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Subject: [Query]: What should we do in txd->tx_submit() and device_issue_pending()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan/Vinod,

I have one query regarding implementation of few routines in DMA drivers.

What the exact purpose of txd->tx_submit() and device_issue_pending() routines?

Should tx_submit() always start physical transfer (Obviously, if channel is free)?
Or should it just queue requests and then finally a call to device_issue_pending()
must start physical transfers?

-- 
viresh
