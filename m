Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0HJKh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 06:37:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51084 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab0HJKhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 06:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ECpavu+R3TLjm4kWKWtLg71lifHA2IfKgLae/B1mLt8V5tksXQVLfYsnu0qhwXEFCT
         dnWPcBKg8NtPn8Zuvhfel21wZArxlw2zBHz9Y1Hl5iMJDUn/SiKGxnPbhRiT8uwiHo3j
         a8w8ELr2c04ij/Ww4gZ3imUB/5tllBe58sYFM=
Date: Tue, 10 Aug 2010 14:37:48 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Battery fixes
Message-ID: <20100810103748.GA20812@oksana.dev.rtsoft.ru>
References: <20100810092700.1814.11982.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100810092700.1814.11982.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 10:27:43AM +0100, Alan Cox wrote:
> Alan Cox (1):
>       intel mid battery: Fix battery scaling
> 
> Arjan van de Ven (1):
>       Fix the argument order to intel_scu_ipc_command in the battery driver

Applied, thanks!
