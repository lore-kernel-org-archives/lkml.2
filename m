Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab0FRNd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:33:59 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:33752 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932184Ab0FRNd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:33:57 -0400
Message-ID: <4C1B75B7.1080104@st.com>
Date: Fri, 18 Jun 2010 19:03:43 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: haavard.skinnemoen@atmel.com, Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "'Shiraz HASHIM'" <shiraz.hashim@st.com>,
       Armando VISCONTI <armando.visconti@st.com>
Subject: Query dw_dmac driver: All descriptors done, but channel not idle!
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have Synopsys Designware DMAC Controller on ST SPEAr13xx platform.
When i run dmatest for all 8 channels then i see following error some times.

"dma dma0chan7: BUG: All descriptors done, but channel not idle!"

I saw the code in driver, and i think it looks to be a known issue for this
peripheral, that's why special handling is done in driver.

Can somebody please confirm, if it a known issue or not? Or if there
are some solutions for this problem.

viresh.
