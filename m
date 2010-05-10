Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0EJFNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:13:44 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:49272 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0EJFNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ArQhK4+8NA26sPTnTpeWa6q+yvFQIHOUrD5kO8XGNFgupXc5GTYOgEV2CrfFT0JfD3
         S+uL5DCAoM/N/v8rJhTOYhN0Ib2nAjNs3e4h/lj95VDL3icnGqUrT+PdkTypWd5pGbhb
         QV9fjsZgM8ch/pU7IQoEE5A7bSk7Vg906mbCk=
MIME-Version: 1.0
In-Reply-To: <20100507222559.GE26579@kroah.com>
References: <alpine.WNT.2.00.1005031333200.4376@jbrandeb-desk1.amr.corp.intel.com>
	 <20100507222559.GE26579@kroah.com>
Date: Sun, 9 May 2010 22:13:40 -0700
X-Google-Sender-Auth: 74ecc18a8dfedcbb
Message-ID: <z2z9929d2391005092213pa4bf9a5fx4c028167749a5497@mail.gmail.com>
Subject: Re: [stable] ixgbe: Fix return of invalid txq
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Greg KH <greg@kroah.com>
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, stable@kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, brandon@ifup.org,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 15:25, Greg KH <greg@kroah.com> wrote:
> On Mon, May 03, 2010 at 01:56:57PM -0700, Brandeburg, Jesse wrote:
>> Please consider commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f for
>> inclusion in 2.6.32.y (it is already in 2.6.33.y)
>>
>> Here is the commit message, it fixes a panic on machines with a larger
>> number of cpus than ixgbe has tx queues (64).
>>
>> commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f
>
> This doesn't apply at all on the .32-stable tree, as the logic has
> changed there.  Care to properly backport it if you really need it
> there?
>
> thanks,
>
> greg k-h
> --

Sorry Greg, I will work on getting you a patch against your stable
tree before tomorrow night.

-- 
Cheers,
Jeff
