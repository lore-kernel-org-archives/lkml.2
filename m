Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab0GNTzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:55:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38500 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909Ab0GNTzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:55:32 -0400
Message-ID: <4C3E162C.4040900@zytor.com>
Date: Wed, 14 Jul 2010 12:55:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ben Greear <greearb@candelatech.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected:  de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com>	<20100713191958.260478c0@virtuousgeek.org>	<4C3E077C.9040609@zytor.com> <20100714115904.7004be74@virtuousgeek.org> <43F901BD926A4E43B106BF17856F0755EA8EEA9B@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755EA8EEA9B@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 12:01 PM, Pan, Jacob jun wrote:
> 
> Can we use PCI_EXT_CAP_NEXT to replace this line?
> pos = (pcie_cap >> 20) & 0xffc
> 

Presumably, I haven't checked the definition of that macro, but that
would be the logical semantics.

	-hpa

