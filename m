Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0DVR0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 13:26:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44770 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0DVR0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 13:26:53 -0400
Message-ID: <4BD086D0.9090309@cs.helsinki.fi>
Date: Thu, 22 Apr 2010 20:26:40 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Shi <alex.shi@intel.com>, yanmin_zhang@linux.intel.com,
       tj@kernel.org
Subject: Re: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vjH.sRSzLB@tosh> <alpine.DEB.2.00.1004221045270.1204@router.home>
In-Reply-To: <alpine.DEB.2.00.1004221045270.1204@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 20 Apr 2010, Rafael J. Wysocki wrote:
> 
>> The following bug entry is on the current list of known regressions
>> from 2.6.33.  Please verify if it still should be listed and let the tracking team
>> know (either way).
> 
> I have not been able to reproduce it so far.

So what are our options? We can revert the SLUB conversion patch for now 
but I still can't see what's wrong with it...

			Pekka
