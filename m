Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab0LOQsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:48:17 -0500
Received: from relay3.sgi.com ([192.48.152.1]:45550 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751213Ab0LOQsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:48:14 -0500
Date: Wed, 15 Dec 2010 10:46:35 -0600
From: Jack Steiner <steiner@sgi.com>
To: Len Brown <lenb@kernel.org>
Cc: hpa@zytor.com, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
Message-ID: <20101215164635.GA27373@sgi.com>
References: <20101214220932.GA1206@sgi.com> <alpine.LFD.2.00.1012141903210.25387@x980> <20101215024136.GB19601@sgi.com> <alpine.LFD.2.00.1012142302110.4878@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012142302110.4878@x980>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 11:03:38PM -0500, Len Brown wrote:
> -       free_initmem();
> +//     free_initmem();
> 
> allows this patch to boot, so the problem is with use of code and 
> data marked __init.
> 
> thanks,
> Len Brown, Intel Open Source Technology Center

Nice catch. I should have caught that.

Do you want me to resend the patch w/o the calls to e820?

--- jack
