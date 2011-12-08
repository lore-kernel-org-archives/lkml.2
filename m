Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab1LHEKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:10:54 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:34854 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547Ab1LHEKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:10:53 -0500
Message-ID: <4EE038BD.7010705@st.com>
Date: Thu, 8 Dec 2011 09:40:37 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        deepak sikri <deepak.sikri@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>, Amit VIRDI <amit.virdi@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: dmaengine/Query: What about scatter/gather for mem to mem transfers.
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan/Vinod

I am looking to implement scatter/gather interface for mem to mem transfers.
But before that, i wanted to know your feedback about it.

In my case, i have memory scattered in pages and performance is not good, if
i submit transfers page by page.

If you are Okay with the idea, i can implement it and submit soon.

-- 
viresh
