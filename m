Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3AELRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 06:17:13 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:51087 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab3AELRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 06:17:11 -0500
MIME-Version: 1.0
In-Reply-To: <50CAA1F2.9000003@asianux.com>
References: <50CAA1F2.9000003@asianux.com>
Date: Sat, 5 Jan 2013 05:17:10 -0600
Message-ID: <CAJ6Av5MP8gjck=WqjLJMLEtHbbaMOT2aFxExP4YkGScE-O0L8A@mail.gmail.com>
Subject: Re: [Suggestion] drivers/staging/tidspbridge: strcpy and strncpy, src
 length checking issue.
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 13, 2012 at 9:50 PM, Chen Gang <gang.chen@asianux.com> wrote:
>   in drivers/staging/tidspbridge/rmgr/proc.c:
>
>     if strlen(drv_datap->base_img) == size, will pass checking (line 397)
>     the size is the full length of exec_file (line 382, line 468..469)
>     strcpy causes issue: src len is strlen(drv_datap->base_img) + '\0'. (line 400)

Good catch.

>     strncpy seems also has issue: need use size instead of strlen(iva_img) + 1. (line 402..403)

This code is not used, it is best to remove it.

Cheers,

Omar
