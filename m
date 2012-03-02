Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650Ab2CBUqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:46:54 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50885 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030608Ab2CBUqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:46:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jgpobox@gmail.com designates 10.52.68.48 as permitted sender) smtp.mail=jgpobox@gmail.com; dkim=pass header.i=jgpobox@gmail.com
Message-ID: <4F5131B9.6010803@pobox.com>
Date: Fri, 02 Mar 2012 15:46:49 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Liu Qiang-B32616 <B32616@freescale.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH V3] fsl-sata: add support for interrupt coalsecing feature
References: <1329291634-883-1-git-send-email-qiang.liu@freescale.com> <CADRPPNTmRvPVymJmW4vagU+2M4DmqeDSEj=4=R_=YDJekOTccQ@mail.gmail.com> <BCB48C05FCE8BC4D9E61E841ECBE6DB70424A8@039-SN2MPN1-012.039d.mgd.msft.net>
In-Reply-To: <BCB48C05FCE8BC4D9E61E841ECBE6DB70424A8@039-SN2MPN1-012.039d.mgd.msft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 09:54 PM, Liu Qiang-B32616 wrote:
> Hi Jeff,
>
> Do you plan to apply it to upstream, or any suggestions? Thanks.

This patch has been in libata-dev (and thus linux-next) for about 2 weeks...



