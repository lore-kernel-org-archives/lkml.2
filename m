Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2KVVM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:12:57 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:18275 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab2KVVMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:12:54 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/ll287oFL0=
X-RZG-CLASS-ID: mo00
Date: Thu, 22 Nov 2012 22:12:48 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, ben@decadent.org.uk,
        thozza@redhat.com, dcbw@redhat.com
Subject: Re: [PATCH V5 3/6] Tools: hv: Add an example script to configure an
 interface
Message-ID: <20121122211248.GA18828@aepfle.de>
References: <1346878188-30822-1-git-send-email-kys@microsoft.com>
 <1346878215-30863-1-git-send-email-kys@microsoft.com>
 <1346878215-30863-3-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1346878215-30863-3-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5558 (2012-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, K. Y. Srinivasan wrote:

> To keep the KVP daemon code free of distro specific details, we invoke an
> external script to configure the interface. This is an example script that
> was used to test the KVP code. This script has to be implemented in a Distro
> specific fashion. For instance on distros that ship with Network Manager enabled,
> this script can be based on NM APIs.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  tools/hv/hv_set_ifconfig.sh |   68 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 68 insertions(+), 0 deletions(-)
>  create mode 100755 tools/hv/hv_set_ifconfig.sh

This already went in, but I overlooked this part:

> +# GATEWAY=ipaddr1

I guest GATEWAY means the default gateway.

> +# GATEWAY_x=ipaddry (where y = x + 1)

How can there be multiple gateways?
Or: What does GATEWAY_n mean here?

Olaf
