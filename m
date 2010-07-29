Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab0G2Wcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 18:32:45 -0400
Received: from fieldses.org ([174.143.236.118]:37273 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab0G2Wco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 18:32:44 -0400
Date: Thu, 29 Jul 2010 18:31:36 -0400
To: Harald Dunkel <harald.dunkel@aixigo.de>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: 2.6.29.6: nfsd: non-standard errno: -9
Message-ID: <20100729223136.GB17999@fieldses.org>
References: <4B30B280.50907@aixigo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B30B280.50907@aixigo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 12:50:24PM +0100, Harald Dunkel wrote:
> Hi folks,
> 
> I get billions of error messages in kern.log syaing
> 
> :
> :
> Dec 22 10:44:55 nasl002a kernel: [ 3676.852579] nfsd: non-standard errno: -9
> Dec 22 10:44:55 nasl002a kernel: [ 3676.906972] nfsd: non-standard errno: -9
> Dec 22 10:44:55 nasl002a kernel: [ 3676.917499] nfsd: non-standard errno: -9
> Dec 22 10:44:55 nasl002a kernel: [ 3676.917742] nfsd: non-standard errno: -9
> Dec 22 10:44:55 nasl002a kernel: [ 3676.917753] nfsd: non-standard errno: -9
> Dec 22 10:44:55 nasl002a kernel: [ 3676.917764] nfsd: non-standard errno: -9
> Dec 22 10:44:55 nasl002a kernel: [ 3676.959585] nfsd: non-standard errno: -9
> Dec 22 10:44:55 nasl002a kernel: [ 3676.959621] nfsd: non-standard errno: -9
> Dec 22 10:44:55 nasl002a kernel: [ 3676.980210] nfsd: non-standard errno: -9
> Dec 22 10:44:55 nasl002a kernel: [ 3676.980613] nfsd: non-standard errno: -9
> :
> :
> 
> This is (supposed to be) NFSv4. The clients are running SunOS 5.10.
> 
> Google doesn't reveal anything, so I wonder whether you have an
> idea?
> 
> 
> Any helpful comments would be highly appreciated.

I suspect this is fixed in:

	git://linux-nfs.org/~bfields/topics.git linux-2.6.36-incoming

If you have the chance to test this and can confirm either way, that
would be helpful.

--b.
