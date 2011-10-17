Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1JQJDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:03:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47359 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1JQJDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <4E9BE18B.5070803@f-secure.com>
References: <4E9BE18B.5070803@f-secure.com>
Date: Mon, 17 Oct 2011 05:03:07 -0400
Message-ID: <CAANzHtS8kCTBkHUwxN_s9ZucrkXHyUvzFzAN7TA7K_XGgiKwxA@mail.gmail.com>
Subject: Re: finger service @ftp.kernel.org
From: =?UTF-8?B?wqA=?= <porpen@gmail.com>
To: Tarkan Erimer <tarkan.erimer@f-secure.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2011 04:04, Tarkan Erimer <tarkan.erimer@f-secure.com> wrote:
> When the finger service will be restored on ftp.kernel.org ?
>
> linux-gpq3:~ # finger @ftp.kernel.org
> finger: Connection refused

http://kernel.org
" Aug 21, 2003: Please don't use finger.kernel.org for any sort of
automatic monitoring. The number of automatic bots hitting this port
is causing the finger daemon to shut down more often than not. The
same information is available from
http://www.kernel.org/kdist/finger_banner. "

The finger_banner page appears to be current, so perhaps switch to this:

curl http://kernel.org/kdist/finger_banner

-porpen
