Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0IAKDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 06:03:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59367 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab0IAKDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 06:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xB7hJymOpzWd/SUxBhZVtDVKjfncqoZyIMv2UZ+IfFfzzUGA0/kXI0RdKBsrp8tgtl
         yu4G6/6lkRKxCk+WnkibIyfZITkYe8ja07O3pBvlDK9uMdGWe9z7+/TlwExkvujjma1E
         HbMZ1bVyYWaPYsiz+UZJZSMbfRA06Ci3Ro4Ws=
MIME-Version: 1.0
In-Reply-To: <20100901085422.GA29145@sirena.org.uk>
References: <1282839933.8133.11.camel@mulgrave.site>
	<20100826092923.4bdbea69.rdunlap@xenotime.net>
	<20100826093838.74ab9958@infradead.org>
	<1283275388.1377.216.camel@gandalf.stny.rr.com>
	<20100831230213.GG2421@linux.vnet.ibm.com>
	<1283296622.1377.765.camel@gandalf.stny.rr.com>
	<987664A83D2D224EAE907B061CE93D53015D9B2445@orsmsx505.amr.corp.intel.com>
	<1283298391.1797.100.camel@Joe-Laptop>
	<1283300616.3284.213.camel@dhcp231-106.rdu.redhat.com>
	<1283301257.1797.105.camel@Joe-Laptop>
	<20100901085422.GA29145@sirena.org.uk>
Date: Wed, 1 Sep 2010 13:03:07 +0300
Message-ID: <AANLkTimuWwneVz=+5uPK=N7gQ2=TCWC2jj7ErNg0CedN@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Joe Perches <joe@perches.com>, Eric Paris <eparis@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 1, 2010 at 11:54 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Aug 31, 2010 at 05:34:17PM -0700, Joe Perches wrote:
>> On Tue, 2010-08-31 at 20:23 -0400, Eric Paris wrote:
>
>> > If I just downloaded a big tar ball and started trolling randomly
>> > through the source how am I going to know what the MAINTAINERS file is?
>
>> I think that tarball trolling is pretty rare these days.
>
> My experience is that there's an awful lot of people working with
> whatever kernel has been provided by their vendor rather than getting
> kernels direct from kernel.org and they tend to only look as far as the
> tarball (or other package) they got.

People that are working with vendor provided kernels do not tend to
contribute upstream. And those who want to contribute will find what
MAINTAINERS is.

>> Any one know the statistics for kernel git traffic vs tarballs?
>
> The kernel.org traffic is going to miss people using distribution or
> other non kernel.org traffic so might be a bit misleading.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
    Sincerely Yours,
        Mike.
