Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0LDXEN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 18:04:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34237 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab0LDXEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 18:04:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OySOUPvKDxO5lg9kBhvQ8Q0pXAqoUH5+LzA2wh6dj/G6VhLrXwYhocMdKLUWtz+Ud7
         vhZM4/fgS8etkol1OwY/sEfbhfg3sBFO+bnt4y15Ra0kN0k1iuoLTJmEnYvz+vn1EJOQ
         QoeXsWCDI53Q968BXHay5y1NbZEa1q9GHh7jg=
MIME-Version: 1.0
In-Reply-To: <1291281270-8195-1-git-send-email-feng.tang@intel.com>
References: <1291281270-8195-1-git-send-email-feng.tang@intel.com>
Date: Sat, 4 Dec 2010 15:04:11 -0800
X-Google-Sender-Auth: B5zSyd5ox57EMY4Ap1arn1OcQ-8
Message-ID: <AANLkTik=cHV+znnCK3+F+v3W5FpAXyroy9rzaEPuzs=t@mail.gmail.com>
Subject: Re: [PATCH] intel_mid_dma: add support for single item scatter-gather list
From: Dan Williams <dan.j.williams@intel.com>
To: Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 2, 2010 at 1:14 AM, Feng Tang <feng.tang@intel.com> wrote:
> Current driver's device_prep_slave_sg can't be used by DMAC2 even
> the sg list contains one item, this patch will enable DMAC2 to
> use this API.
>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Acked-by: Vinod Koul <vinod.koul@intel.com>

Applied.

--
Dan
