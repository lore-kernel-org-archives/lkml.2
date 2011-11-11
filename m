Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab1KKRlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:41:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab1KKRlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:41:10 -0500
Date: Fri, 11 Nov 2011 09:40:53 -0800
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/2] pciehp: wait 100 ms after Link Training check
Message-ID: <20111111174053.GA27014@suse.de>
References: <4EB88238.4050409@oracle.com>
 <4EB8F434.6090003@jp.fujitsu.com>
 <4EB94A51.6070809@oracle.com>
 <4EB9A50D.1040302@oracle.com>
 <4EBB7F9B.8050703@jp.fujitsu.com>
 <4EBB8058.6090500@jp.fujitsu.com>
 <4EBC21C0.5070806@oracle.com>
 <20111111093212.3cceee91@jbarnes-desktop>
 <4EBD5C6C.9010606@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBD5C6C.9010606@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 09:33:32AM -0800, Yinghai Lu wrote:
> On 11/11/2011 09:32 AM, Jesse Barnes wrote:
> 
> > On Thu, 10 Nov 2011 11:10:56 -0800
> > Yinghai Lu <yinghai.lu@oracle.com> wrote:
> > 
> >> On 11/09/2011 11:42 PM, Kenji Kaneshige wrote:
> >>
> >>> If the port supports Link speeds greater than 5.0 GT/s, we must wait
> >>> for 100 ms after Link training completes before sending configuration
> >>> request.
> >>>
> >>> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> >>
> >>
> >>
> >> Acked-by: Yinghai Lu <yinghai@kernel.org>
> >> Tested-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > Applied these two to my for-linus branch, thanks guys.
> > 
> 
> 
> Thanks, We may need to put them into stable too.

Then send stable@vger.kernel.org the git commit ids once they show up in
Linus's tree.

thanks,

greg k-h
