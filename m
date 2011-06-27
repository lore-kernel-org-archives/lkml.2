Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1F0TOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 15:14:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38461 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1F0TOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 15:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=Gp609gDr6lbAQMWgS6QtVozmFxQAoWFyUlHt4FLOXfnqccspdtqXz0QmPwYCMcvH56
         sTi1/iuFo6slFiHt+ucuN3XfJtzlf9bqtP1clLZKQTicnsOvXD5OlAOZjypQ8EWyZdbp
         NqqoNRMevTAc4tUxWcLWbiN0tVHDCCoXQT4T0=
Subject: Re: [RFC] ubiblk: read-only block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: david.wagner@free-electrons.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Jun 2011 22:14:30 +0300
In-Reply-To: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1309202072.24805.4.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks, for the driver.

On Fri, 2011-06-24 at 15:34 +0200, david.wagner@free-electrons.com
wrote:
> I'm submitting it for review, comments (on the concept as well as on the
> implementation) and advice.  It is my first kernel module - a lot of code was
> taken from mtd_blkdevs and some from gluebi.

If you borrow code from anywhere, you should preserve Copyrights.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

