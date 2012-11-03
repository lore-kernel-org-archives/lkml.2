Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173Ab2KCEHR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 00:07:17 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:40153 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2KCEHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 00:07:15 -0400
Date: Fri, 2 Nov 2012 21:07:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 0/4] 3.0.51-stable review
Message-ID: <20121103040711.GD1602@kroah.com>
References: <20121102170333.581931288@linuxfoundation.org>
 <20121103003108.GA1981@optiplex.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103003108.GA1981@optiplex.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 10:31:10PM -0200, Rafael Aquini wrote:
> On Fri, Nov 02, 2012 at 10:06:04AM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.0.51 release.
> > There are 4 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun Nov  4 17:03:28 UTC 2012.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.51-rc1.gz
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     Linux 3.0.51-rc1
> > 
> > Ben Skeggs <bskeggs@redhat.com>
> >     drm/nouveau: silence modesetting spam on pre-gf8 chipsets
> > 
> > Jan Kara <jack@suse.cz>
> >     mm: fix XFS oops due to dirty pages without buffers on s390
> > 
> 
> Howdy Greg,
> 
> Somehow the following patch is missing for this series submission:
> > Len Brown <len.brown@intel.com>
> >     x86: Remove the ancient and deprecated disable_hlt() and enable_hlt() facility
> 
> I glanced at the the downloadable consolidated patch and its hunks seem to be present,
> though.

I do not understand.  Where do you not see it?  It's in the patch on
kernel.org, right?  Where is it missing?

confused,

greg k-h
