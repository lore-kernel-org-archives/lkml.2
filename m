Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1JPJWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 05:22:17 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48623 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab1JPJWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 05:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+O4pCL8PSyfSV+8eNTspicqfad96Z=NXhE0n-wYeKVgJOJrGg@mail.gmail.com>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
	<20111012141724.GA17414@suse.de>
	<CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com>
	<20111012203337.GA14572@suse.de>
	<CA+O4pCKfem5nAQvpRWBZp21XsE6Z3Nn1iDW9yosuQ3fLqhtZ1A@mail.gmail.com>
	<CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
	<CAHFNz9JUV6wabQxsvrxPRX6q41sWNMDy8DJcOpNTecNTbL=XaQ@mail.gmail.com>
	<CA+O4pCJ2gDicdC7BbCbo0m3xdCX0cdhY-Azn9aqu6+C58u0kgQ@mail.gmail.com>
	<CAHFNz9+a4PjsAoBYF-bJ9nSOzNtEVq23UJzxSTxo=fdmSGOJPw@mail.gmail.com>
	<CA+O4pC+Qo0VVM26RZXkKs18vJ-uG-YGp1vxtKBr0nzRSOitPtA@mail.gmail.com>
	<CA+O4pCL8PSyfSV+8eNTspicqfad96Z=NXhE0n-wYeKVgJOJrGg@mail.gmail.com>
Date: Sun, 16 Oct 2011 10:22:13 +0100
Message-ID: <CAAMvbhHr2--e=ZH02qV=7otdFY-xFpMR2o-0+OoMoSuG_AnpZg@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Manu Abraham <abraham.manu@gmail.com>, Greg KH <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 October 2011 10:29, Markus Rechberger <mrechberger@gmail.com> wrote:
>
> Some demonstration video:
> (with 24064 bytes, which uses the additional buffers which are allowed
> by the introduced patch):
> Flawlessly video:
> http://www.sundtek.de/support/00011.MTS
>
> (Alan's proposed buffer size 11776/12288)
> Jerky video:
> http://www.sundtek.de/support/00012.MTS
>
> both videos are around 30 seconds made with a camera, video is still uploading.
> this is my last post to that topic I still have some little hope that
> this patch will get in to fix that issue.
> As proposed for academic research you can pick up a Stick in Berlin
> once the new cut is ready from manufacturing,
>

Can you post the actual captured stream, and not a video camera copy
of a media player playing the stream.
