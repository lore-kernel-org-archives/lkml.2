Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2BAR57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:57:59 -0500
Received: from mtv-iport-3.cisco.com ([173.36.130.14]:49319 "EHLO
	mtv-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab2BAR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:57:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EACB8KU+rRDoI/2dsb2JhbABDrFWCKYEFgXIBAQEEEgFlARALGAkWDwkDAgECAUUGDQEHAQEeoVIBnl6LMgEEAgECAgkCAgEGBwMTAQgFAwMJHAMBgnEZBAMMAxQFVw0BBAQMAgoCgz0EiEGMYIVXjR0
X-IronPort-AV: E=Sophos;i="4.71,603,1320624000"; 
   d="scan'208";a="28245135"
Message-ID: <4F297D25.7090902@cisco.com>
Date: Wed, 01 Feb 2012 10:57:57 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
CC: "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: VFs go missing with latest kernel
References: <4F287102.3060600@cisco.com> <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com> <4F2887AB.8070005@cisco.com> <C5551D9AAB213A418B7FD5E4A6F30A0702F64AF6@ORSMSX106.amr.corp.intel.com> <4F288C4A.3070509@cisco.com> <C5551D9AAB213A418B7FD5E4A6F30A0702F64B7F@ORSMSX106.amr.corp.intel.com> <C5551D9AAB213A418B7FD5E4A6F30A0702F66ADF@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <C5551D9AAB213A418B7FD5E4A6F30A0702F66ADF@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 10:47 AM, Rose, Gregory V wrote:
> I found this in the log file you sent me.  I had missed it yesterday.
> 
> [   15.835223] igb 0000:07:00.0: 7 pre-allocated VFs found - override max_vfs setting of 7
> [   15.835393] igb 0000:07:00.0: 7 VFs allocated
> 
> I think that must be a bug in the code that searches for VFs already allocated and is the source of your problem.  I'll keep you updated on what I find but it has to be a bug in the VF device lookups.

Confused. What is pre-allocating the VFs during boot? Looking at my
rc-scripts I am only set MAC addresses at boot. No VMs have been started
yet. This setup has worked fine with Fedora 14 and 3.0 kernels; it's
really the move to 3.3-rc that I hit the problem.

David
