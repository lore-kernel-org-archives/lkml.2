Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2CBNvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 08:51:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55922 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab2CBNvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 08:51:50 -0500
Message-ID: <4F50D06E.1020604@canonical.com>
Date: Fri, 02 Mar 2012 14:51:42 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120224 Thunderbird/11.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/34] 2.6.32.58-longterm review
References: <20120301214654.GA13231@kroah.com> <20120302071914.GC13959@1wt.eu>
In-Reply-To: <20120302071914.GC13959@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.03.2012 08:19, Willy Tarreau wrote:
> Hi Greg,
>
> On Thu, Mar 01, 2012 at 01:46:54PM -0800, Greg KH wrote:
>> NOTE:
>> 	I have NOT tested this rc release.  I now no longer own any
>> 	machines that can run the 2.6.32 kernel.  Because of this, this
>> 	will be the last 2.6.32-longterm kernel that I will release.  I
>> 	will be passing on the .32 kernel to someone else after this
>> 	release.  Please, if you care about the .32 kernel, test this
>> 	release, I have _only_ build tested it, and have no idea if I
>> 	got something wrong or not.
>
> OK, tested here on an atom-based netbook (x86-32+i915 graphics).
> WiFi (incl firmware loading), bluetooth (over USB), NFS, suspend/resume,
> ACPI were tested with success. So I think that once again you did the job
> right till your last release :-)
>
> Cheers,
> Willy
>
FWIW, tested too on a AMD Turion based laptop (x86_64+ATI X1200 graphics).
Ok, not exactly that but the 2.6.32.58+drm33. But that one also did not show 
obvious problems.

-Stefan

> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

