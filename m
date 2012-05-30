Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab2E3PAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:00:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52163 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab2E3PAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:00:10 -0400
Date: Wed, 30 May 2012 17:00:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andre Przywara <andre.przywara@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
        konrad.wilk@oracle.com, jeremy@goop.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, stable@vger.kernel.org.#.3.4+
Subject: Re: [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity systems
Message-ID: <20120530150007.GB15438@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andre Przywara <andre.przywara@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
	konrad.wilk@oracle.com, jeremy@goop.org,
	linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
	stable@vger.kernel.org.#.3.4+
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC631D3.9080907@zytor.com>
 <20120530145523.GA15635@x1.osrc.amd.com>
 <4FC6358F.2010405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC6358F.2010405@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 07:58:23AM -0700, H. Peter Anvin wrote:
> If so, then fix the description to match reality and we can take the patch.

Andre, would you please do that?

Thanks.

-- 
Regards/Gruss,
Boris.
