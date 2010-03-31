Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab0CaKQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 06:16:33 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33092 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151Ab0CaKQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=aMgXBlIaX0slV5mPZPg2vWjY9D6dL4zsOdzSFaI2WEww7bXgInD6gRtY8M954D8CtQ
         NxZeyPnytUxbMEZnvDshkGzPblMruoSjf0DQ+XsOFq7VLh/cO4Oh0Z2OMTgqOkJB5OAv
         9kSO2W0ASeX0XQZWa8InJK+ypeeKv/f2ebOCM=
MIME-Version: 1.0
In-Reply-To: <n2m72cf309c1003310300k26b9aacbob7b49ff2f43f949d@mail.gmail.com>
References: <n2m72cf309c1003310300k26b9aacbob7b49ff2f43f949d@mail.gmail.com>
From: Sachin Pandhare <sachinpandhare@gmail.com>
Date: Wed, 31 Mar 2010 15:40:24 +0530
Message-ID: <g2n72cf309c1003310310pa0fabc7fw1824d17316e0f0a@mail.gmail.com>
Subject: Re: kmemleak_scan_area
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sachin <sachinpandhare@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, corrected myself in the code snippet
struct kmemleak_scan_area {
instead of
struct kmemleak_scan_area_node {

On Wed, Mar 31, 2010 at 3:30 PM, Sachin Pandhare
<sachinpandhare@gmail.com> wrote:
> Hi Catalin,
> In kmemleak.c file "kmemleak_scan_area" is appearing as a structure as
> well as a function.
> e.g.:
> - struct kmemleak_scan_area {
> - void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
>
> Do you think it is a good to have it like that?
>
> regards,
> Sachin
>
