Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab2DXI0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:26:41 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:55994 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754838Ab2DXI0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:26:39 -0400
Message-ID: <4F966345.5080303@st.com>
Date: Tue, 24 Apr 2012 10:24:37 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@st.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "jgarzik@redhat.com" <jgarzik@redhat.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        spear-devel <spear-devel@list.st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        ML netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH V2 6/9] net/stmmac: Remove conditional compilation of
 clk code
References: <cover.1335246730.git.viresh.kumar@st.com> <4336df4e231467d253e25bbd41dbce6d189ed1e8.1335246730.git.viresh.kumar@st.com> <4F964551.4050507@st.com> <4F96493C.7020309@st.com> <4F964B3A.306@st.com>
In-Reply-To: <4F964B3A.306@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/2012 8:42 AM, Viresh Kumar wrote:
> On 4/24/2012 12:03 PM, Giuseppe CAVALLARO wrote:
>> Oops, sorry but on a build I got:
>>
>>  CC      init/version.o
>>   LD      init/built-in.o
>>   LD      .tmp_vmlinux1
>> drivers/built-in.o: In function `stmmac_release':
>> /stlinux/cavagiu/git/mirror/net-next.git/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:1134:
>> undefined reference to `clk_disable'
>> drivers/built-in.o: In function `stmmac_open':
>> /stlinux/cavagiu/git/mirror/net-next.git/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:974:
>> undefined reference to `clk_enable'
>> /stlinux/cavagiu/git/mirror/net-next.git/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:1079:
>> undefined reference to `clk_disable'
>> drivers/built-in.o: In function `stmmac_dvr_probe':
>> /stlinux/cavagiu/git/mirror/net-next.git/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:1931:
>> undefined reference to `clk_get'
>> drivers/built-in.o: In function `stmmac_clk_csr_set':
>> /stlinux/cavagiu/git/mirror/net-next.git/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:174:
>> undefined reference to `clk_get_rate'
>> drivers/built-in.o: In function `stmmac_suspend':
>> /stlinux/cavagiu/git/mirror/net-next.git/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2030:
>> undefined reference to `clk_disable'
>> drivers/built-in.o: In function `stmmac_resume':
>> /stlinux/cavagiu/git/mirror/net-next.git/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2054:
>> undefined reference to `clk_enable'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> Pls, can you verify?
> 
> I believe, you haven't applied:
> 
> [PATCH V2 1/9] clk: Add non CONFIG_HAVE_CLK routines
> 
> which must be applied before testing this.

Yes with it applied the build is ok.

Peppe

> 

