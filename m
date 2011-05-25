Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab1EYMNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:13:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62831 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab1EYMNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JDPJfE+cABnH0NpB/G1fhquSk6awsKtC0Qtr9AVQs8FKo5v9/SxfdU46UvvxiFg3VO
         E0V4Sfr7ZN899ICXzZ9KfFsB7/nulMhCCwgfh6mgcBQls4qD8Ns0YSALTLupK39NyPXT
         mmaR7GLdxdg/f8vOsjsd7cuTMWZbDt4TS1ng8=
MIME-Version: 1.0
In-Reply-To: <20110525092449.GJ14556@legolas.emea.dhcp.ti.com>
References: <20110520161816.dda6f1fd.sfr@canb.auug.org.au> <BANLkTimjzzqTS1fELmpb0UivqseLsYOfPw@mail.gmail.com>
 <BANLkTine2kobQA8TkmtiuXdKL=07NCo2vA@mail.gmail.com> <BANLkTim-zRShhy49d7yn5WTJYzR6A2DtZQ@mail.gmail.com>
 <BANLkTi=U8ikZo65AoxGznCopGMTFOUXWhQ@mail.gmail.com> <20110525092449.GJ14556@legolas.emea.dhcp.ti.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 25 May 2011 08:13:20 -0400
Message-ID: <BANLkTimd_CmVzJP1yDkuNSS+PSRk=0W_uA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
To: balbi@ti.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 05:24, Felipe Balbi wrote:
> On Tue, May 24, 2011 at 01:10:42PM -0400, Mike Frysinger wrote:
>> latest tree seems to only fail for me now on the musb driver.  i can
>> send out a patch later today if no one else has gotten to it yet.
>
> please do send out, but what was the compile breakage with musb ?

i logged it earlier in the thread:
drivers/usb/musb/musb_core.c: In function 'musb_write_fifo':
drivers/usb/musb/musb_core.c:219: error: implicit declaration of
function 'prefetch'
make[3]: *** [drivers/usb/musb/musb_core.o] Error 1

patch sent out now
-mike
