Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1AJSr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:47:29 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34254 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab1AJSr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:47:27 -0500
Message-ID: <4D2B543A.3070609@austin.ibm.com>
Date: Mon, 10 Jan 2011 12:47:22 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 0/4] De-couple sysfs memory directories from memory sections
References: <4D2B4B38.80102@austin.ibm.com> <20110110184416.GA18974@kroah.com>
In-Reply-To: <20110110184416.GA18974@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 12:44 PM, Greg KH wrote:
> On Mon, Jan 10, 2011 at 12:08:56PM -0600, Nathan Fontenot wrote:
>> This is a re-send of the remaining patches that did not make it
>> into the last kernel release for de-coupling sysfs memory
>> directories from memory sections.  The first three patches of the
>> previous set went in, and this is the remaining patches that
>> need to be applied.
> 
> Well, it's a bit late right now, as we are merging stuff that is already
> in our trees, and we are busy with that, so this is likely to be ignored
> until after .38-rc1 is out.
> 
> So, care to resend this after .38-rc1 is out so people can pay attention
> to it?

I was afraid of this. I didn't get a chance to get it out sooner but thought
I would send it out anyway.

> 
> 
>> The root of this issue is in sysfs directory creation. Every time
>> a directory is created a string compare is done against all sibling
>> directories to ensure we do not create duplicates.  The list of
>> directory nodes in sysfs is kept as an unsorted list which results
>> in this being an exponentially longer operation as the number of
>> directories are created.
> 
> Are you sure this is still an issue?  I thought we solved this last
> kernel or so with a simple patch?

I'll go back and look at this again.

thanks,
-Nathan
