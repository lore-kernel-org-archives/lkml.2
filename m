Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0HZQBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:01:33 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48324 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab0HZQB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=VdS9DJPvsekuGispv9+3UDH+Y3AM/QpIL94sBcFf01KSdInYhplk/PAL+Z2U/USzvQ
         FwEc67eFv4VN+BdAuVFzbfx3NzFdM5V6hU+zOoUocDYIDxY1BiKJpoD21Xf7LitNcmxc
         mVoEC+oHFADuQwD8somYkB5TGVm4G7FZ+to3o=
Date: Thu, 26 Aug 2010 09:01:26 -0700
From: mark gross <markgross@thegnar.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] pm_qos: Fix inline documentation.
Message-ID: <20100826160126.GA3414@gvim.org>
Reply-To: markgross@thegnar.org
References: <1282801975-18348-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282801975-18348-1-git-send-email-skannan@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: mark gross <markgross@thegnar.org>

thanks!

--mgross



On Wed, Aug 25, 2010 at 10:52:55PM -0700, Saravana Kannan wrote:
> Change-Id: I32f95b5a7e92236931b38fc4f1474f46ad22e298
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>  kernel/pm_qos_params.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index 996a4de..132471f 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -212,15 +212,17 @@ EXPORT_SYMBOL_GPL(pm_qos_request_active);
>  
>  /**
>   * pm_qos_add_request - inserts new qos request into the list
> - * @pm_qos_class: identifies which list of qos request to us
> + * @dep: pointer to a preallocated handle
> + * @pm_qos_class: identifies which list of qos request to use
>   * @value: defines the qos request
>   *
>   * This function inserts a new entry in the pm_qos_class list of requested qos
>   * performance characteristics.  It recomputes the aggregate QoS expectations
> - * for the pm_qos_class of parameters, and returns the pm_qos_request list
> - * element as a handle for use in updating and removal.  Call needs to save
> - * this handle for later use.
> + * for the pm_qos_class of parameters and initializes the pm_qos_request_list
> + * handle.  Caller needs to save this handle for later use in updates and
> + * removal.
>   */
> +
>  void pm_qos_add_request(struct pm_qos_request_list *dep,
>  			int pm_qos_class, s32 value)
>  {
> -- 
> 1.7.1.1
> ---
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
