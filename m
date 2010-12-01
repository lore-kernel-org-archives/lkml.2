Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0LARLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:11:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43729 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab0LARLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:11:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FWNfixcsVDViIVR+/5SiEsfbeQhdnDFn4eg1cvRp+Oegr7Ob9o3ANcrzxmWx7x8p1I
         NAjZD7e3MpebSkFm2AzjI+6ir67tnF2eoxamsUlqDiGl7swgAKvgDIrfkyjH4EghXkgr
         884gnJxYs5F36CQzqc5BCZsqxVairngTQvqqw=
Subject: Re: [PATCH] USB: whci-hcd: fix compiler warning
From: Namhyung Kim <namhyung@gmail.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CF68087.2090802@csr.com>
References: <1291177721-17598-1-git-send-email-namhyung@gmail.com>
	 <20101201161039.GB29318@suse.de> <1291222151.1684.46.camel@leonhard>
	 <4CF67D5F.3080609@csr.com> <1291222944.1684.48.camel@leonhard>
	 <4CF68087.2090802@csr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 02:11:02 +0900
Message-ID: <1291223462.1684.51.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-01 (수), 17:06 +0000, David Vrabel:
> Actually CONFIG_MODULES is wrong. It needs to test if the driver has
> been built as a module or not.  I think there's a __MODULE__ or MODULE
> #define for this, not sure though.
> 
> David

Right, we use MODULE. I was just thinking about that :)

-- 
Regards,
Namhyung Kim


