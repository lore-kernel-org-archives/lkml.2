Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1B1K6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:58:46 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:42465 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753560Ab1B1K6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:58:45 -0500
Message-ID: <4D6B7FC9.4020905@st.com>
Date: Mon, 28 Feb 2011 16:28:17 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Subject: Re: [PATCH 3/8 resend] dw_dmac: call dwc_scan_descriptor from dwc_issue_pending
 only if active list is empty
References: <cover.1298889267.git.viresh.kumar@st.com> <8003205172278ef36cfca1fd50a54cb143fad958.1298889267.git.viresh.kumar@st.com> <20110228104635.GB2754@pulham.picochip.com>
In-Reply-To: <20110228104635.GB2754@pulham.picochip.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2011 04:16 PM, Jamie Iles wrote:
> On Mon, Feb 28, 2011 at 04:11:18PM +0530, Viresh Kumar wrote:
>> > dwc_scan_descriptor was called even when there were descriptors in active list.
>> > Checking if active list is empty or not.
>> > 
>> > Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> Hi Viresh,
> 
> I have a similar patch to this that is already in next that should 
> achieve the same thing (dmaengine/dw_dmac: don't scan descriptors if no 
> xfers in progress).

Jamie,

Sorry for missing that!!
This patch can be dropped.

-- 
viresh
