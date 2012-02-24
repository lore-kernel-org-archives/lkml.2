Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab2BXNcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:32:05 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61550 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2BXNcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:32:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120224122755.GA2106@x2.net.home>
References: <20120224122755.GA2106@x2.net.home>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Fri, 24 Feb 2012 14:31:37 +0100
Message-ID: <CAGm1_ktDhLd=YCT+zfAjQPwTKH+NLGTwew4Wc42wnwLm00RVTw@mail.gmail.com>
Subject: Re: [ANNOUNCE] util-linux v2.21
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karel,

On Fri, Feb 24, 2012 at 1:27 PM, Karel Zak <kzak@redhat.com> wrote:
>
> The util-linux release v2.21 is available at
>
>  ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.21
>
> Feedback and bug reports, as always, are welcomed.

You asked for it :-)

I tried to cross-compile the package under Buildroot and got following error:

checking whether __progname is defined... yes
checking whether the target supports thread-local storage... yes
configure: error: in `buildroot/output/build/util-linux-2.21':
configure: error: cannot run test program while cross compiling

Could you disable tests for cross-compilation case?

Regards,
Yegor
