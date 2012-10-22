Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab2JVKSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:18:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47161 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab2JVKSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:18:07 -0400
Date: Mon, 22 Oct 2012 12:18:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Do not change worker's running cpu in
 cmci_rediscover().
Message-ID: <20121022101804.GC8352@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tang Chen <tangchen@cn.fujitsu.com>,
	"Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
	"laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
	"wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
 <1350625528-1385-3-git-send-email-tangchen@cn.fujitsu.com>
 <20121019164233.GF11958@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F19D57AA5@ORSMSX108.amr.corp.intel.com>
 <5084BE7C.4020303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5084BE7C.4020303@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:33:16AM +0800, Tang Chen wrote:
> I have 2 nodes, node0 and node1. node1 could be hotpluged.
> node0 has cpu0 ~ cpu15, node1 has cpu16 ~ cpu31.
> 
> I online all the cpus on node1, and hot-remove node1 directly.

Hold on, I need to ask here: you soft-online all cores on node1 and
*then* you *hot* *remove* it? So with all cores online you physically
take out the processor from the socket? Am I reading this correctly?

Thanks.

-- 
Regards/Gruss,
    Boris.
