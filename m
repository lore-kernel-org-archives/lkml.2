Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab1DZFhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:37:19 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:43088 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531Ab1DZFhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:37:14 -0400
Message-ID: <4DB659E7.1000505@st.com>
Date: Tue, 26 Apr 2011 11:06:39 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [PATCH V2 0/7] dmaengine/dw_dmac updates
References: <cover.1303194835.git.viresh.kumar@st.com> <1303789619.896.4.camel@vkoul-udesk3>
In-Reply-To: <1303789619.896.4.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 09:16 AM, Koul, Vinod wrote:
> The patch series fails to apply in my next. Can you please rebase to my
> tree and resend again
> 
> FWIW: my tree is at git://git.infradead.org/users/vkoul/slave-dma.git

Ya Sure. Will resend them.
But when i tried to apply them on your next, they applied without any issues.

I used

$git am -3 *.patch

-- 
viresh
