Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1BVTiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:38:14 -0500
Received: from smtp-out.google.com ([74.125.121.67]:34333 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1BVTiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:38:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bCti86rSl70QyYTwoGSdCyNCMVSn/9ScxIv4CYA+Tj8SZU+6wCDYzEp41L6beoXRAM
         2k6/mqOwY2/yt+SgImtg==
MIME-Version: 1.0
In-Reply-To: <1298342392-21236-1-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
Date: Tue, 22 Feb 2011 11:38:09 -0800
X-Google-Sender-Auth: RHRmWdnBlWIt-bq_u3-_c0aW7D4
Message-ID: <AANLkTimHJX4oqyiQ4rNF2YBgb3NyiixjU_wHP5Yd3Kpo@mail.gmail.com>
Subject: Re: [PATCH 0/7] Second batch of Tegra clock updates for 2.6.39
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: konkers@android.com, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mike@compulab.co.il
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pushed everything except the last patch that disables bootloader
clocks to for-next.  I'll repost the last change with Olof's comments
addressed.

On Mon, Feb 21, 2011 at 6:39 PM, Colin Cross <ccross@android.com> wrote:
> This patch series contains two small patches out of the previous
> series that needed fixes, as well as some new ones to disable
> unused clocks during boot and related bug fixes.
>
> Patch 4 converts the Harmony and Trimslice boards to use the new
> init_early machine handler.  Any boards that go in after this
> patch will need to be updated to match, and this patch will need
> to be updated if any boards go in before this patch.
>
> Tested-bys on Harmony and Trimslice would be appreciated.
>
>
