Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2GKFDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:03:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25319 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2GKFDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:03:18 -0400
Message-ID: <4FFD0908.6080506@oracle.com>
Date: Wed, 11 Jul 2012 13:03:04 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Dave, Tushar N" <tushar.n.dave@intel.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 82571EB: Detected Hardware Unit Hang
References: <4FFA9B96.6040901@oracle.com> <4FFBDC50.5090800@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EE41F@ORSMSX102.amr.corp.intel.com> <4FFCCA22.8060006@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EEC8B@ORSMSX102.amr.corp.intel.com> <4FFCDA6C.8020708@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EED74@ORSMSX102.amr.corp.intel.com> <4FFCF314.6020400@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA891274EEDD7@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <061C8A8601E8EE4CA8D8FD6990CEA891274EEDD7@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/12 12:05, Dave, Tushar N wrote:
> When you said you had this issue with RHEL5 and RHEL6 drivers, have you install RHEl5/6 kernel and reproduced it? If so I think I should install RHEL6 and try reproduce it locally!
> 
Yes I reproduced this on both RHEL5 and RHEL6.

So far I tried to scp big file (~1GB) will hit it at once.

Thanks,
Joe
