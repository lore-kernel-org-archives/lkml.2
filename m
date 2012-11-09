Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab2KIBWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 20:22:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38379 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab2KIBWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 20:22:41 -0500
Message-ID: <509C5ACD.4040706@oracle.com>
Date: Fri, 09 Nov 2012 09:22:21 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
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
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/12 04:35, Dave, Tushar N wrote:
> Are you sure this is not similar issue as before that you reported.
> i.e. 

Tushar,

Thanks for your quick response, I'll check with customer if they can modify the Max
payload size from BIOS, this time issue hit on HP's server.

Thanks again,
Joe

> On Mon, 2012-07-09 at 16:51 +0800, Joe Jin wrote:
>> > I'm seeing a Unit Hang even with the latest e1000e driver 2.0.0 when 
>> > doing scp test. this issue is easy do reproduced on SUN FIRE X2270 M2, 
>> > just copy a big file (>500M) from another server will hit it at once.
> All devices in path from root complex to 82571, should have *same* max payload size otherwise it can cause hang. 
> Can you double check this?
> 


-- 
Oracle <http://www.oracle.com>
Joe Jin | Software Development Senior Manager | +8610.6106.5624
ORACLE | Linux and Virtualization
No. 24 Zhongguancun Software Park, Haidian District | 100193 Beijing 
