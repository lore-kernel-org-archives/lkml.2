Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab0JFVE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:04:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51054 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab0JFVE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:04:26 -0400
Message-ID: <4CACE41F.1020905@kernel.org>
Date: Wed, 06 Oct 2010 14:03:27 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.32.y] ipmi: Fix hard-code path ipmi exit path panic
References: <4C9CDEEF.4030304@kernel.org> <20101006210120.GB6184@kroah.com>
In-Reply-To: <20101006210120.GB6184@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 02:01 PM, Greg KH wrote:
> On Fri, Sep 24, 2010 at 10:25:03AM -0700, Yinghai Lu wrote:
>>
>> Wing found panic on X4800, after he installed Sun own special version of ipmitool.
> 
> Is this an issue on 2.6.35?  If so, please lt the ipmi maintainer know
> about it so this patch can get into Linus's tree and then backported to
> the stable releases.

only for 2.6.32.y

Yinghai


