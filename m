Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab2KNCsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:48:11 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49044 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab2KNCsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:48:09 -0500
Message-ID: <50A30656.6090508@oracle.com>
Date: Wed, 14 Nov 2012 10:47:50 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Dave, Tushar N" <tushar.n.dave@intel.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mary Mcgrath <mary.mcgrath@oracle.com>
Subject: Re: 82571EB: Detected Hardware Unit Hang
References: <509B5038.8090304@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/12 04:35, Dave, Tushar N wrote:
> All devices in path from root complex to 82571, should have *same* max payload size otherwise it can cause hang. 
> Can you double check this?

Hi Tushar,

Checked with hardware vendor and they said no way to modify the max payload size 
from BIOS, can I modify it from driver side?

Thanks,
Joe
