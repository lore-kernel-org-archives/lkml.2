Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1EIFpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:45:45 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:54996 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508Ab1EIFpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:45:44 -0400
Message-ID: <4DC77F67.80400@st.com>
Date: Mon, 9 May 2011 11:15:11 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH V4 1/5] dmaengine/dw_dmac: don't call callback routine
 in case dmaengine_terminate_all() is called
References: <cover.1304596524.git.viresh.kumar@st.com>	 <8d1b15be425a70cdbd30725b88bd303cc74e706d.1304596524.git.viresh.kumar@st.com> <1304917371.32447.10.camel@vkoul-udesk3>
In-Reply-To: <1304917371.32447.10.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 10:32 AM, Koul, Vinod wrote:
> How about changing this to:
> 	if (callback_required && callback)
> 		callback(param)
> This will make it look cleaner ...

Sure. Will resend.

-- 
viresh
