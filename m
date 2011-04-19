Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1DSX0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:26:41 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:35950 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751761Ab1DSX0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:26:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=K2wnc6rEBcb/NbJVWNct590ggajAVtCzhEz+FCT2D2C2O4pJ02espMI6ju9O+3h0/+uRgoGPf4nOFY79cfIK14cHNc9/iWmQu3L60WepFYtPEOhnescUloYfBsZ18FKb;
Date: Tue, 19 Apr 2011 16:26:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: james_p_freyensee@linux.intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 2/4] Kernel documentation for the PTI feature.
Message-Id: <20110419162637.cd29a016.rdunlap@xenotime.net>
In-Reply-To: <1303253889-10074-3-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
	<1303253889-10074-3-git-send-email-james_p_freyensee@linux.intel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 15:58:07 -0700 james_p_freyensee@linux.intel.com wrote:

> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This provides Kernel documentation for the PTI
> feature and setting line discipline drivers
> on top of tty's for Linux mobile solutions.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> ---
>  Documentation/pti/pti_intel_mid.txt |   99 +++++++++++++++++++++++++++++++++++
>  1 files changed, 99 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/pti/pti_intel_mid.txt
> 
> diff --git a/Documentation/pti/pti_intel_mid.txt b/Documentation/pti/pti_intel_mid.txt
> new file mode 100644
> index 0000000..900f6db
> --- /dev/null
> +++ b/Documentation/pti/pti_intel_mid.txt
> @@ -0,0 +1,99 @@
> +The Intel MID PTI project is HW implemented in Intel Atom
> +system-on-a-chip designs based on the Parallel Trace
> +Interface for MIPI P1149.7 cJTAG standard.  The kernel solution
> +for this platform involves the following files:
> +
> +./include/linux/pti.h
> +./drivers/.../n_tracesink.h
> +./drivers/.../n_tracerouter.c
> +./drivers/.../n_tracesink.c
> +./drivers/.../pti.c
> +
> +pti.c is the driver that enables various debugging features
> +popular on certain mobile manufacturers.

   popular on devices | platforms | chips | whatever from certain mobile
   manufacturers.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
