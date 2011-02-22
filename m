Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1BVSiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:38:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:1974 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab1BVSiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:38:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,207,1297065600"; 
   d="scan'208";a="711856746"
Subject: Re: [PATCH 01/12] export kernel call get_task_comm()
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
In-Reply-To: <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
	 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
	 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 22 Feb 2011 10:38:06 -0800
Message-ID: <1298399886.2315.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg:

Is this a patch you will or have already take/taken?  Or do you want me
to re-submit this with the rest of the patches like last time?  

My default is I will re-send you all of these patches with the changes
we talked about last week.

thanks,
jay

On Tue, 2011-02-08 at 11:34 -0800, james_p_freyensee@linux.intel.com
wrote:
> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This allows drivers who call this function to be compiled modularly.
> Otherwise, a driver who is interested in this type of functionality
> has to implement their own.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> ---
>  fs/exec.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index c62efcb..7b209f9 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -998,6 +998,7 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
>  	task_unlock(tsk);
>  	return buf;
>  }
> +EXPORT_SYMBOL_GPL(get_task_comm);
>  
>  void set_task_comm(struct task_struct *tsk, char *buf)
>  {


