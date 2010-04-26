Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0DZWG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:06:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63804 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab0DZWGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:06:54 -0400
Message-ID: <4BD60DF2.2070406@oracle.com>
Date: Mon, 26 Apr 2010 15:04:34 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: [PATCH -v5] reserve a0000 - 0x10000
References: <4BC4E55B.7000103@oracle.com>	<20100426183436.GV11130@hexapodia.org>	<20100426123135.5d095d2f@virtuousgeek.org>	<201004261427.57229.bjorn.helgaas@hp.com>	<20100426133757.3e1d0a75@virtuousgeek.org>	<a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com> <20100426142546.2e77b1ba@virtuousgeek.org> <4BD60CD5.4060601@oracle.com>
In-Reply-To: <4BD60CD5.4060601@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BD60E5A.0129:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for memo, sending out -v5 
