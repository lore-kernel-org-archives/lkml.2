Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab2AFAkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 19:40:47 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59266 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab2AFAkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 19:40:46 -0500
MIME-Version: 1.0
In-Reply-To: <1325665240.1862.37.camel@epip-laptop>
References: <1325665240.1862.37.camel@epip-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jan 2012 16:40:24 -0800
X-Google-Sender-Auth: Q3UeQyGmtN1Q4L3dpoHH2wcRgm4
Message-ID: <CA+55aFzLoqtnvNAqSWk1=e5_M+13MiU3gqh0A9=DrQwe4UPWhg@mail.gmail.com>
Subject: Re: [Pull: unicore32] Please pull unicore32 bugfix patches
To: gxt@mprc.pku.edu.cn
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 12:20 AM, Guan Xuetao <gxt@mprc.pku.edu.cn> wrote:
> Hi, Linus,
>  Could you please pull unicore32 bugfix patches from my repo:
>        git://github.com/gxt/linux.git unicore32
>
>  There are 10 patches in unicore32 branch with their logs listed below.

Please use the standard git request-pull format, which gives shortlog
and diffstat information. That's useful for me to actually verify that
what I get matches the pull request, in ways that the raw log messages
are not.

                     Linus
