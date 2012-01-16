Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2APKsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:48:53 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:45290 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753401Ab2APKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:48:52 -0500
X-AntiVirus: Checked by Dr.Web [version: 6.0.3.08040, engine: 6.0.100.10070, virus records: 2539054, updated: 16.01.2012]
Message-ID: <4F14004F.2010906@ru.mvista.com>
Date: Mon, 16 Jan 2012 14:47:43 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@st.com>
CC: vinod.koul@intel.com, dan.j.williams@intel.com, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, linux@arm.linux.org.uk, bhupesh.sharma@st.com,
        armando.visconti@st.com, linus.walleij@linaro.org, mirko.gardi@st.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
        amit.virdi@st.com, vipulkumar.samar@st.com, viresh.linux@gmail.com,
        deepak.sikri@st.com, bhavna.yadav@st.com,
        linux-arm-kernel@lists.infradead.org, vincenzo.frascino@st.com
Subject: Re: [PATCH 5/8] dmaengine/dw_dmac: Use platform_get_drvdata instead
 of accessing dev directly
References: <cover.1326707233.git.viresh.kumar@st.com> <51d3263224d48c1d68de1449af28fb1570900254.1326707233.git.viresh.kumar@st.com>
In-Reply-To: <51d3263224d48c1d68de1449af28fb1570900254.1326707233.git.viresh.kumar@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 16-01-2012 13:50, Viresh Kumar wrote:

> Use already defined function platform_get_drvdata() instead of accessing
> pdev->dev.data.

    pdev->dev.platform_data.

> Signed-off-by: Viresh Kumar<viresh.kumar@st.com>

WBR, Sergei

