Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab2IRMel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:34:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab2IRMek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:34:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH v5 00/17] Introduce Xen support on ARM (based on 3.6-rc5)
Date: Tue, 18 Sep 2012 12:34:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>
References: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209181234.29557.arnd@arndb.de>
X-Provags-ID: V02:K0:bcMTw+7UhK/ACDTwV5qA3ZZHptjq/o/6VKOclcPohqU
 HQ4eEYiFzFJ6Vcclkk0ycZj9Ft2OdkfJdHKm60IHK8mDDj4HSl
 JL4CpovXoiZh8Chskt0Ejt1hF+8BX0Jxh6k+ZriO5WJke3NdJc
 tCQZf1bK/Q+sAdVVQY/HGxvPdPk6KBLWy/qhled3PwdLBrFRud
 89miQ7zCprpkSLwa9HHKG/XtUoFAAv7fwPJ6n9K+QylLEdtRgt
 tglroBjozQqLkIYAA1AqsZNIp02JcUSFEgaWTJp6E/SqCE/Zau
 1IlmJGTAQx+Qtx6DLKbV/xLK2/kU21tUpEf5bwz8OORHspFJre
 FQ5LMtfZRuLGLcXORCW4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2012, Stefano Stabellini wrote:

> I am also attaching to this email the dts'es that I am currently using
> for dom0 and domU: vexpress-v2p-ca15-tc1.dts (that includes
> vexpress-v2m-rs1-rtsm.dtsi) is the dts used for dom0 and it is passed to
> Linux by Xen, while vexpress-virt.dts is the dts used for other domUs
> and it is appended in binary form to the guest kernel image. I am not
> sure where they are supposed to live yet, so I am just attaching them
> here so that people can actually try out this series if they want to.

You can submit the dts files separately so we can include them in
the arm-soc tree. Pawel Moll is handling vexpress related changes these
days, so it would be reasonable if he included them in a pull request.
 
> The patch series has been rebased on Konrad's stable/for-linus-3.7
> branch.
> 
> Arnd, Russell, what do you think about this series? If you are OK with
> it, to whom should I submit it?

I have no objections to your patches from this series. IMHO they should
be submitted through the Xen tree, but it would be good to have an Ack
from Russell.

	Arnd
