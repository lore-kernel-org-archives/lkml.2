Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab0KPHxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:53:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40976 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478Ab0KPHxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:53:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=j2I+MDzanmcYFX53h4NKJuWC0ITpgQsxp5GAVmILd4mvZQhr3xP9/ll1opFR6/Nt8G
         +DOCD3e6H1NgmcNlIbWvpl5T7AYYC/0IHHlGIoZTBuX048txTMMLiST7KeTIM+1GjJOP
         yGZrnIFqsL6BsYtHgc6R+tYcEDS498gCgHOnU=
MIME-Version: 1.0
In-Reply-To: <20101116072247.GQ14383@tux1.beaverton.ibm.com>
References: <20101116072247.GQ14383@tux1.beaverton.ibm.com>
Date: Tue, 16 Nov 2010 17:53:35 +1000
Message-ID: <AANLkTin16PNdYh61Zhy=5ttMrL-VuSYYkCRybXo6wFo=@mail.gmail.com>
Subject: Re: Incorrect size checks on mmap() for sysfs PCI resource files is
 breaking X?
From: Dave Airlie <airlied@gmail.com>
To: djwong@us.ibm.com
Cc: Martin Wilck <martin.wilck@ts.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 5:22 PM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> Hi,
>
> I just loaded 2.6.37-rc2 on my machines, and I noticed that X no longer starts.
> Running an strace of the X server shows that it's doing this:

Can you poinpoint when it went wrong? does 2.6.36 work okay?

Just trying to figure out where the regression arrived.

Dave.
