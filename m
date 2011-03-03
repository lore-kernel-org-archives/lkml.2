Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab1CCQJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:09:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40523 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1CCQJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:09:12 -0500
Message-ID: <4D6FBD04.6090702@oracle.com>
Date: Thu, 03 Mar 2011 08:08:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        driverdevel <devel@driverdev.osuosl.org>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] staging/brcm80211: fix printk format warnings
References: <20110301181119.f1c7a9c3.sfr@canb.auug.org.au> <20110301162948.34c28d6e.randy.dunlap@oracle.com> <20110302210511.GA20798@kroah.com> <20110303103620.6b3c463f.sfr@canb.auug.org.au> <20110303072028.GA21427@sdf-MacBook>
In-Reply-To: <20110303072028.GA21427@sdf-MacBook>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D6FBD0C.0114,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/11 23:20, Stanislav Fomichev wrote:
>> Maybe due to conflict resolutions in my tree (assuming that Randy based
>> his patch in linux-next).
> We don't have brcm80211/sys/ directory (it was renamed to
> brcm80211/brcmsmac); so it's based on the wrong/outdated tree.

It was based on linux-next of 2011-0301, which is what the patch email
was in reply to.

> And I suppose these errors are already fixed.

Good to know.  Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
