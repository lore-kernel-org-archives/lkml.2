Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab0D3RtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:49:19 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:57135 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab0D3RrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:47:20 -0400
X-Greylist: delayed 2912 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2010 13:47:19 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q8SIIbh6G22/EQcJ7iNwcF+XPOY3GCyZlhglxt0KNUe8hYIf4MF2t89OoM3x8sCOcA
         nbpUWADZLtnawapsgzWYwvQhI103er7nEdnRoADxiF8bGbDL/N04JQkfoOYVu/PltWqM
         fKCAtJeHB5jKWN9TwhFVB1K5kwW9knQJgdkqE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004301201450.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>
	 <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>
	 <1272399798.2255.2.camel@localhost>
	 <1272400246.2255.5.camel@localhost>
	 <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com>
	 <20100429151555.GM17639@pcarmody-desktop>
	 <y2xe6bf505b1004290852xa079969k3316c5bb7233de13@mail.gmail.com>
	 <alpine.LFD.2.00.1004301201450.2951@localhost.localdomain>
Date: Fri, 30 Apr 2010 09:04:18 -0500
Message-ID: <y2re6bf505b1004300704qd27ca301h3fd4df80cdad244f@mail.gmail.com>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>,
       john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 5:02 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 29 Apr 2010, Xianghua Xiao wrote:
>> I confirm that 2.6.33.3-rt15 worked fine, reboot/umount will not oops.
>
> Just pushed out 2.6.33.3-rt17 which has the problem fixed. Can you
> please verify that it works for you as well ?
>
> Thanks,
>
>        tglx
>

Yes it works fine now.
Thanks a lot for the efforts!
Xianghua
