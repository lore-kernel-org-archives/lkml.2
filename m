Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1ATQLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:11:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62794 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab1ATQL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:11:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P/u8BezXXylbBMTv1pjRZGp2sOuj3SbTgLAG1Mkbuvq1sQ+ccKFd/X1J6ETjVMgfo1
         AvyNgcswQgwy3JVZj+89yfjGvgvlmDnyGk4TzXabqkqumN3QJvrlap/J6B4CJOlI51u7
         OO47B7V47F/MWj5hYisxCirq7lP/BaevDrwSo=
MIME-Version: 1.0
In-Reply-To: <201101201226.41021.rjw@sisk.pl>
References: <201101201226.41021.rjw@sisk.pl>
Date: Fri, 21 Jan 2011 00:06:55 +0800
Message-ID: <AANLkTikVRHfu2KhH4yi2VerkRXBdCODedCDORmpEzRXO@mail.gmail.com>
Subject: Re: [PATCH 0/11] ACPI: Fixes and cleanups related to iomaps management
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 7:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> [10/11] - Make the NVS code use existing iomaps if possible.

Seems ok.

> [11/11] - (cleanup) Remove an unnecessary field from struct nvs_page.

This seems to have an issue. Notebook tries to suspend ... then resume
immediately.

> The patches have been tested on HP nx6325, Toshiba Portege R500 and Acer
> Ferrari One without causing any visible problems to happen.  Also Jeff has
> tested [1/11] and [2/11] and he reports that they fix the synchronize_rcu()
> problem for him.  [Jeff, can you test the whole series, please, and see if
> it doesn't introduce any new issues, [10/11] in particular?]

So, everything seems ok except 11/11.


Jeff.
