Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2EUMDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:03:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55076 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2EUMDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:03:12 -0400
MIME-Version: 1.0
In-Reply-To: <7559275.nOXNfWAdxV@avalon>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
	<1337520203-29147-6-git-send-email-akinobu.mita@gmail.com>
	<7559275.nOXNfWAdxV@avalon>
Date: Mon, 21 May 2012 21:03:10 +0900
Message-ID: <CAC5umyiOa=e2DRE3fK=5p6D49uO=QKiQds=sFvQgQ=1osZFgZw@mail.gmail.com>
Subject: Re: [PATCH 06/10] video/uvc: use memweight()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/21 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Akinobu,
>
> Thank you for the patch.
>
> On Sunday 20 May 2012 22:23:19 Akinobu Mita wrote:
>> Use memweight() to count the total number of bits set in memory area.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: linux-media@vger.kernel.org
>
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>

You meant Acked-by, didn't you?
