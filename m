Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0JNTd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:33:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35019 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab0JNTd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ev1QMBoHbbyXSHQftVUoeRuSo6MNi5bhPBfI/rJNfv+gLKHyv/berQAYEOMVrXMRx9
         M4X6xfXcJAmvtilj1jzgF/RFhhwFHA4R2tzB7gsCQ1yyzDg/cdGZrHXQOsAAOIwwz318
         6IdIgOSD0rQZQY7PcqYVNPJVvG8fUy0yCIVL4=
MIME-Version: 1.0
In-Reply-To: <20101004172807.GA10189@srcf.ucam.org>
References: <20101004171520.4B0189D401B@zog.reactivated.net>
	<20101004172807.GA10189@srcf.ucam.org>
Date: Thu, 14 Oct 2010 20:33:27 +0100
X-Google-Sender-Auth: 1DWCauNiU0rkaGE1gUJJqDordF0
Message-ID: <AANLkTik7iFTCkvoZfw3iy6BamhQG_6FzabpKuu4V0G7A@mail.gmail.com>
Subject: Re: [PATCH] Add OLPC XO-1 rfkill driver
From: Daniel Drake <dsd@laptop.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: dilinger@queued.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On 4 October 2010 18:28, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> +     printk(KERN_INFO "%s: loading\n", pdev->name);
>
> Probably don't need this. Otherwise, looks fine.

Thanks for reviewing.
I posted an updated patch here:
https://patchwork.kernel.org/patch/233031/

The supporting arch/x86 code has now been merged into the x86 tree, so
can the rfkill driver now go into yours?

Thanks,
Daniel
