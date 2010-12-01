Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0LARCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:02:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41141 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab0LARCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:02:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IXd6xaBocf4T+rUVwIhRYRxaoQxmZBVtZC1sDNJSygjbO5myEZo4Eu3SPNvvH1cFRw
         J+M6BANjFtxZ9PTlIHheRQkunwyXSFk42Jn/PyqC+QReao3+RVjY+bO8PuxKzLKgVKbO
         1RQhwjtc2oSdiIs0Up3MvyqD+IWfTPCtM50FY=
Subject: Re: [PATCH] USB: whci-hcd: fix compiler warning
From: Namhyung Kim <namhyung@gmail.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CF67D5F.3080609@csr.com>
References: <1291177721-17598-1-git-send-email-namhyung@gmail.com>
	 <20101201161039.GB29318@suse.de> <1291222151.1684.46.camel@leonhard>
	 <4CF67D5F.3080609@csr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 02:02:24 +0900
Message-ID: <1291222944.1684.48.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-01 (수), 16:52 +0000, David Vrabel:
> Namhyung Kim wrote:
> > I saw it during allyesconfig build but not on allmodconfig.
> > Maybe we can wrap it up in #ifdef CONFIG_MODULES ?
> 
> That might be best.  Can you do the same with drivers/uwb/whc-rc.c?  It
> will have the same problem.
> 
> David

No problem. Will send them soon. :)
Thanks.

-- 
Regards,
Namhyung Kim


