Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0KIJnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:43:24 -0500
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:9329 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0KIJnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:43:20 -0500
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=sslHRcvV0REGGnFvfpOTnI/L53p192v1GjYTRa9+brpCH23ghbY5NR7A
   WSKXdT9eVlCxkjSEMNjfnIU9cWn3KVLD7w7UwCqvlyUhVS0FuQ+wM8H7i
   hQZN5eDbP5bzzEEuBF9FeWFPgxcihFWCKi+CrRpm1pG0Um1drGvYZcD8D
   fvPf+MgL7zN9YXyKxj463vFFV5MK09r/fM4MFP0GSho+YCBPcFUBcBDKZ
   o2LSzLZvG0JxETvse8KXq0GQ7hDdI;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.59,174,1288566000"; 
   d="scan'208";a="58384468"
X-IronPort-AV: E=Sophos;i="4.59,173,1288566000"; 
   d="scan'208";a="102514896"
Message-ID: <4CD917AB.6070705@ts.fujitsu.com>
Date: Tue, 09 Nov 2010 10:43:07 +0100
From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Organization: Fujitsu Technology Solutions
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de-AT; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wichert, Gerhard" <gerhard.wichert@ts.fujitsu.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] fix size checks for mmap() on /proc/bus/pci files (resent)
References: <4cbffbf8.Qhs/h1a0ymU/N8ON%martin.wilck@ts.fujitsu.com>
In-Reply-To: <4cbffbf8.Qhs/h1a0ymU/N8ON%martin.wilck@ts.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse & linux-pci,

may I kindly ask if anyone has had a look at this patch yet?

https://patchwork.kernel.org/patch/270271/
http://kerneltrap.org/mailarchive/linux-kernel/2010/10/21/4635039

Regards
Martin

-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

FUJITSU
Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany
Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck@ts.fujitsu.com
Internet:		http://ts.fujitsu.com
Company Details:	http://ts.fujitsu.com/imprint
