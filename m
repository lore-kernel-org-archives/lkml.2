Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2KHOeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:34:37 -0500
Received: from mo-p04-ob.rzone.de ([81.169.146.177]:60969 "EHLO
	mo-p04-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2KHOeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:34:36 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2012 09:34:35 EST
X-RZG-CLASS-ID: mo04
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRNV67U=
Date: Thu, 8 Nov 2012 15:19:25 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Tomas Hozza <thozza@redhat.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com
Subject: Re: [PATCH] Tools: hv: Fix for long file names from readdir
Message-ID: <20121108141925.GA20083@aepfle.de>
References: <1352383995-13856-1-git-send-email-thozza@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1352383995-13856-1-git-send-email-thozza@redhat.com>
User-Agent: Mutt/1.5.21.rev5558 (2012-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, Tomas Hozza wrote:

> kvp_get_if_name and kvp_mac_to_if_name copy strings into statically
> sized buffers which could be too small to store really long names.

> -	char dev_id[256];
> +	char dev_id[512];

Shouldnt that be PATH_MAX or similar?

Olaf
