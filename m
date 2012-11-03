Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2KCLpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:45:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2KCLpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 07:45:19 -0400
Date: Sat, 3 Nov 2012 09:45:02 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 0/4] 3.0.51-stable review
Message-ID: <20121103114501.GA1688@optiplex.redhat.com>
References: <20121102170333.581931288@linuxfoundation.org>
 <20121103003108.GA1981@optiplex.redhat.com>
 <20121103040711.GD1602@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103040711.GD1602@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 09:07:11PM -0700, Greg Kroah-Hartman wrote:
> > 
> > Howdy Greg,
> > 
> > Somehow the following patch is missing for this series submission:
> > > Len Brown <len.brown@intel.com>
> > >     x86: Remove the ancient and deprecated disable_hlt() and enable_hlt() facility
> > 
> > I glanced at the the downloadable consolidated patch and its hunks seem to be present,
> > though.
> 
> I do not understand.  Where do you not see it?  It's in the patch on
> kernel.org, right?  Where is it missing?
> 

The LKML patch series is missing PATCH 02/04.



> confused,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
