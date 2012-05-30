Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2E3PRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:17:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39388 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab2E3PRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:17:03 -0400
Message-ID: <4FC63996.9040706@zytor.com>
Date: Wed, 30 May 2012 08:15:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Andre Przywara <andre.przywara@amd.com>, mingo@elte.hu, jeremy@goop.org,
        tglx@linutronix.de, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org#3.4+
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity
 systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com> <20120530143937.GF3207@phenom.dumpdata.com> <4FC633A7.1050406@zytor.com> <4FC6540E0200007800086EF7@nat28.tlf.novell.com>
In-Reply-To: <4FC6540E0200007800086EF7@nat28.tlf.novell.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 08:08 AM, Jan Beulich wrote:
> 
> Xen does trap and emulate (possibly just ignore) both instructions.
> 

Then why the fsck is there paravirt_crap on this?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

