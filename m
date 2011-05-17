Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1EQRnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:43:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48903 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab1EQRnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:43:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eeN3i2seTeyTEnoDfA16FEZkn6U7u4zUeHkJ7F/ZUsZwejvgAOwx8NmkJcn556+ebX
         rFBnT6Ln8KkURZS04Q9Y+krda9ViUenUfMyk8R0xEFmnR6p9F0Ammqigmq14T4sjQDfy
         YlZNPokQytVdFxxsDioCnYNVWJ0lezApjoha8=
MIME-Version: 1.0
In-Reply-To: <1305653342.2182.15.camel@anish-desktop>
References: <1305653342.2182.15.camel@anish-desktop>
Date: Tue, 17 May 2011 18:43:11 +0100
X-Google-Sender-Auth: B8r9C8IJ56BmP21W4QH2AXZqhEY
Message-ID: <BANLkTi=AGbuU-jyhqaSF+yXA3qQuKVLWfA@mail.gmail.com>
Subject: Re: [PATCH 2/2] trivial: Changed the printk loglevel when not able to
 allocate memory
From: Catalin Marinas <catalin.marinas@arm.com>
To: anish <anish198519851985@gmail.com>
Cc: linux@arm.linux.org.uk, lethal@linux-sh.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 May 2011 18:29, anish <anish198519851985@gmail.com> wrote:
> When not able to allocate memory we were using KERN_INFO as
> log level in printk so changed to KERN_ERR
>  Signed-off-by: anish kumar<anish198519851985@gmail.com>

Maybe KERN_WARN?

-- 
Catalin
