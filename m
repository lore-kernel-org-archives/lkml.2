Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1CQMPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:15:30 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44895 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1CQMP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:15:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OcqFZoGe+cSvjYKZXq4mGVMnArBXE5bNzxLx7Iffk+FAsa7mehWOd/VqQKLotMlZzC
         7MsBZcFxaKen45llpXWwH2iNGbQqBjXDfhYyisSH68i7ukL7qP3d2v8Ea8MtkjlrjUgO
         WDiU0l/gDk+O7ierC7XtWK1Ok+LSCV9YIi78U=
MIME-Version: 1.0
In-Reply-To: <20110317113229.GA7710@albatros>
References: <1299780740-32652-1-git-send-email-segoon@openwall.com>
 <AANLkTimPZJoCzz386e-4m0Y4khWGZirZguGFmuFYCrry@mail.gmail.com>
 <4D7F5CAC.6070006@trash.net> <20110317113229.GA7710@albatros>
From: Changli Gao <xiaosuo@gmail.com>
Date: Thu, 17 Mar 2011 20:15:06 +0800
Message-ID: <AANLkTimtsB0B98E2xcoJgRsPwSpwuG+ahT+LX0s1YwpX@mail.gmail.com>
Subject: Re: [PATCH v2] ipv4: netfilter: ipt_CLUSTERIP: fix buffer overflow
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        security@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 7:32 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> 'buffer' string is copied from userspace.  It is not checked whether it is
> zero terminated.  This may lead to overflow inside of simple_strtoul().
> Changli Gao suggested to copy not more than user supplied 'size' bytes.
>
> It was introduced before the git epoch.  Files "ipt_CLUSTERIP/*" are
> root writable only by default, however, on some setups permissions might be
> relaxed to e.g. network admin user.
>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Changli Gao <xiaosuo@gmail.com>


-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
