Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2B1EjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 23:39:07 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55103 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755539Ab2B1EjD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 23:39:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.182.202.69 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <20120228130634.3c511b096bc78f9b99e804fe@canb.auug.org.au>
References: <20120228130634.3c511b096bc78f9b99e804fe@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 27 Feb 2012 21:38:43 -0700
X-Google-Sender-Auth: lfpGwq1nuXzfcf4aonRF359o68U
Message-ID: <CACxGe6sLLxUL4U3fP6dOSOu+tYaMZkG6z7RWHqp-CX06Ztp1CQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the devicetree tree with the powerpc tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 7:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next merge of the devicetree tree got a conflict in
> arch/powerpc/platforms/iseries/Kconfig between commit 3d066d77cf46
> ("powerpc: remove CONFIG_PPC_ISERIES from the architecture Kconfig
> files") from the powerpc tree and commit 0f22dd395fc4 ("of: Only compile
> OF_DYNAMIC on PowerPC pseries and iseries") from the devicetree tree.
>
> The former commit removes the file (as the legacy iSeries platform is
> being removed), so I did that.

Okay, thanks.

g.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
