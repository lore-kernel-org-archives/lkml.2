Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1BJSn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:43:59 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63650 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1BJSn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:43:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vIZpUXoxyH+UAfYTJqEeIZaqnTWSW9m8WYXikJh86NeUIEJzAOfcvFl9MCPzqa2se9
         d2JDTE6dqeEOTRoManrCH2CEa+A0jUjKlWQmNDwzuYQuontvqI3ZGQTwpnQh69vivGkh
         4MtskZpuY/9s8TltPr8QFjnMUqQGOXVGvb2tY=
MIME-Version: 1.0
In-Reply-To: <20110210175855.GC13795@suse.de>
References: <0d30dc$l1diqi@orsmga001.jf.intel.com>
	<20110210175855.GC13795@suse.de>
Date: Thu, 10 Feb 2011 20:43:57 +0200
Message-ID: <AANLkTimyxSy2FDBjh-xR1XmuZ9c7KjYHN-CjFAfp4Eu_@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] Intel(R) MEI Driver
From: Tomas Winkler <tomasw@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Oren Weil <oren.jer.weil@intel.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, david@woodhou.se,
        david.woodhouse@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 7:58 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Feb 10, 2011 at 01:54:54AM -0800, Oren Weil wrote:
>> Intel(R) Management Engine Interface (Intel(R) MEI) Driver
>> ==========================================================
>>
>> This patch contains a new Intel driver for the Linux kernel: The Intel(R) MEI Driver.
>
> This patch?  What patch, there is no patch here.
>
> You sent out 13 emails with the same exact Subject line, which is not
> acceptable at all, and mighty confusing.
>
>> This set of patches is for review purposes; the driver code
>> for pull is in the David Woodhouse public git repository:
>> http://git.infradead.org/linux-2.6-mei.git
>
> No, we need these as patches, not as a pull request.  Please work on
> fixing up your individual patches, that's the only way this is going to
> be accepted.

There was a suggestion of splitting the driver into per file patches
to be reviewable  rather then creating gigantic driver patch.
I personally would prefer the later one  would happy to here any other
suggestions how to split driver.

Thanks
Tomas
