Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1GFQRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:17:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48079 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1GFQRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:17:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAD6i1fK0nH+D3v+A3erC1PgR=S=709H9ZC=T8-q0gqV1ghA0bQ@mail.gmail.com>
References: <20110706074934.GA935@mail.fossee.in> <20110706155745.GB16625@suse.de>
 <CAD6i1fK0nH+D3v+A3erC1PgR=S=709H9ZC=T8-q0gqV1ghA0bQ@mail.gmail.com>
From: Prashant Shah <pshah.mumbai@gmail.com>
Date: Wed, 6 Jul 2011 21:47:17 +0530
Message-ID: <CAD6i1f+_+P7Eb1GD0E1+iufBXAyYWzYYHC-G0OvxOreAFG-ukA@mail.gmail.com>
Subject: Re: [PATCH] Staging: msm: fixed style issues found by checkpatch.pl
To: Greg KH <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 9:45 PM, Prashant Shah <pshah.mumbai@gmail.com> wrote:
> On Wed, Jul 6, 2011 at 9:27 PM, Greg KH <gregkh@suse.de> wrote:
>> On Wed, Jul 06, 2011 at 01:19:34PM +0530, Prashant P. Shah wrote:
>> Also, did you successfully build this code before and after your
>> changes?
>
> I tried but the code does not build because of #include <mach/board.h>
> in the msm_fb.c file. I dont know how to fix that.
>

there are few #include <mach/..> ins the source files that dont
compile on my machine.
