Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab2CMMTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab2CMMTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:19:19 -0400
Date: Tue, 13 Mar 2012 13:19:14 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
Message-ID: <20120313121914.GA2957@host2.jankratochvil.net>
References: <4F5A3A4D.1020008@redhat.com>
 <20120309172934.GA18173@host2.jankratochvil.net>
 <4F5DE6A4.2030303@redhat.com>
 <20120312165359.GA32400@host2.jankratochvil.net>
 <4F5E4757.705@redhat.com>
 <4F5F39B9.1090109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5F39B9.1090109@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 13:12:41 +0100, Denys Vlasenko wrote:
> ec1fd70dbee0db36eff9527254d9d2bbfd260f13 0x2093 - /usr/bin/md5sum
> ec1fd70dbee0db36eff9527254d9d2bbfd260f13 0x1659 - /usr/bin/md5sum
> 
> If anyone would want to use this tool on a large collection
> of coredumps with the intent of fishing out similar crashes

In such moment it is already on public Internet and the build-id -> name
mapping database is available.

Or it rather would be available if the Darkserver would be finished.  So far
I have only always seen every project for build-id targeted at getting rid of
the build-id and map it back to the ambiguous filenames / package names.

In such case there could filename / package name already in the ELF header.
build-id should be there as a feature, not as a complication.


> (this is not a theoretical assumption, we *do* have people
> who badly need this feature), they won't get nice names of binaries,

If someone does 'cp /usr/bin/md5sum ~/bin/mysum' then you either get
unidentifiable names or even misleading names.


Regards,
Jan
