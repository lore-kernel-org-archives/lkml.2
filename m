Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0KRKMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:12:21 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47033 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab0KRKMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hu1ld+VglI8/O33Lzf5Y+XzLV+TPkqO9YsUDpdE7Pk/nlONsadmHeswbCrxXoEijgJ
         lHR9DAgoiCRA9PVDocPhaQXOEDHoMmF14SAKtuyKPxQnoeN9833+RK3q6Bsf4H5GqFfd
         r7CPck48BOTIG7ymD/dRuBh/bxiR0pY+x1VUo=
Date: Thu, 18 Nov 2010 18:17:04 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Pavel Machek <pma@sysgo.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        vgoyal@redhat.com, akpm@linux-foundation.org, randy.dunlap@oracle.com
Subject: Re: kexec documentation missing, bad links in kdump.txt
Message-ID: <20101118101704.GC5171@cr0.nay.redhat.com>
References: <20101118095015.GA12071@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118095015.GA12071@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:50:15AM +0100, Pavel Machek wrote:
>Hi!
>
>Where can one get kexec documentation?
>
>(In particular, we are trying to get it to boot on ARM board, and
>wonder if something like CONFIG_RELOCATABLE_KERNEL is needed.)
>


If you want to use the same kernel as the crash kernel, yes,
you have to support relocatable during boot on your arch.


>Unfortunately, only pieces mentioning kexec are kdump pieces
>(Documentation/kdump/kdump.txt), and links there, such as
>
>http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools.tar.gz
>
>http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/README.html
>
>http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools.git
>
>are no longer valid :-(.

Try:

 git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git


