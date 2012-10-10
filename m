Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab2JJPRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:17:06 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36165 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab2JJPRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:17:03 -0400
Date: Wed, 10 Oct 2012 10:12:45 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: your mail
Message-ID: <20121010151245.GB1650@ennui.austin.ibm.com>
References: <20121010150653.GA1350@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010150653.GA1350@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12101015-1976-0000-0000-0000123A9EE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Please ignore.

On Wed, Oct 10, 2012 at 10:06:53AM -0500, Kent Yoder wrote:
> The following changes since commit ecefbd94b834fa32559d854646d777c56749ef1c:
> 
>   Merge tag 'kvm-3.7-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2012-10-04 09:30:33 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://github.com/shpedoikal/linux.git tpmdd-fixes-v3.6
> 
> for you to fetch changes up to 1631cfb7cee28388b04aef6c0a73050f6fd76e4d:
> 
>   driver/char/tpm: fix regression causesd by ppi (2012-10-10 09:50:56 -0500)
> 
> ----------------------------------------------------------------
> Gang Wei (1):
>       driver/char/tpm: fix regression causesd by ppi
> 
>  drivers/char/tpm/tpm.c     |  3 ++-
>  drivers/char/tpm/tpm.h     |  9 +++++++--
>  drivers/char/tpm/tpm_ppi.c | 18 ++++++++++--------
>  3 files changed, 19 insertions(+), 11 deletions(-)

