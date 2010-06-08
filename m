Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0FHMP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 08:15:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891Ab0FHMP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 08:15:57 -0400
Date: Tue, 8 Jun 2010 14:15:43 +0200
From: Karel Zak <kzak@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.18-rc1
Message-ID: <20100608121542.GA2200@nb.net.home>
References: <20100608104618.GA18342@nb.net.home> <E1OLwWP-0003Wp-ST@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OLwWP-0003Wp-ST@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 12:59:05PM +0200, Miklos Szeredi wrote:
> On Tue, 8 Jun 2010, Karel Zak wrote:
> > umount(8):
> >   - supports new command line option "-f/--fake" to avoid umount(2) syscall
> 
> I think you just mean "--fake",  -f is --force.

 Yes. Fixed in ReleaseNotes, thanks.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
