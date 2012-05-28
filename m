Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2E1O4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:56:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51937 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2E1O42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:56:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120420020013.GA19964@windriver.com>
References: <20120420020013.GA19964@windriver.com>
Date: Mon, 28 May 2012 15:56:27 +0100
Message-ID: <CAPM=9tzcAW=zhMcS4daBEeFyh5TffcYud8Lo-ooA6zuoeT-yjQ@mail.gmail.com>
Subject: Re: linux-next: triage for April 19, 2012
From: Dave Airlie <airlied@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 3:00 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> The "undefined reference to `vga_default_device'" stuff appears to
> still be unresolved, as it was in the Apr 19 fails still.     :-(
> [ https://lkml.org/lkml/2012/4/18/157 ]
>

Can you say what arch/logs had this fail in it?

If its only m68k then hopefully Geert merges his patch to fix it.

Dave.
