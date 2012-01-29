Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab2A2Lik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 06:38:40 -0500
Received: from ozlabs.org ([203.10.76.45]:38579 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab2A2Lij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 06:38:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add kernel parameter to disable module load
In-Reply-To: <20120128033450.GA2138@darkstar>
References: <20120128033450.GA2138@darkstar>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 29 Jan 2012 11:21:30 +1030
Message-ID: <87vcnvbab1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jan 2012 11:34:50 +0800, Dave Young <dyoung@redhat.com> wrote:
> Sometimes we need to test a kernel of same version with code or config
> option changes.
> 
> We already have sysctl to disable module load, but add a kernel
> parameter will be more convenient.


> +static int __init module_load_disable(char *str)
> +{
> +	modules_disabled = 1;
> +	return 1;
> +}
> +__setup("nomodule", module_load_disable);

You misspelled core_param here :)

Thanks,
Rusty.
