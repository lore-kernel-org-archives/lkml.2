Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab1KVJ3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:29:49 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:53145 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab1KVJ3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:29:47 -0500
X-IronPort-AV: E=Sophos;i="4.69,552,1315180800"; 
   d="scan'208";a="9057711"
Subject: Re: [PATCH 3/4] xen/granttable: Grant tables V2 implementation
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "annie.li@oracle.com" <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Date: Tue, 22 Nov 2011 09:29:46 +0000
In-Reply-To: <1321927161-3987-1-git-send-email-annie.li@oracle.com>
References: <4ECA416D.90602@oracle.com>
	 <1321927161-3987-1-git-send-email-annie.li@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1321954186.3664.403.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 01:59 +0000, annie.li@oracle.com wrote:
[...]
> +#ifdef CONFIG_X86
> +		barrier();
> +#else
> +		mb();
> +#endif
> +		}

Niggle: Indentation of this final } is off.

Otherwise all 4 patches:
Acked-by: Ian Campbell <ian.campbell@citrix.com>

[...]

