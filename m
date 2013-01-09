Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab3AIDXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 22:23:18 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:58641 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab3AIDXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 22:23:17 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <CAOesGMgdV1dD5stpCiWVO8kL+E9U4+_3Zc7gUQ0YEiah4t1LbQ@mail.gmail.com>
References: <20130108184920.GA1258@quad.lixom.net>
	<CA+55aFxxv2h8TAxvwprdQEpaz4Ww5ime+t8rmpjnjv2t-mWYaQ@mail.gmail.com>
	<CAOesGMgdV1dD5stpCiWVO8kL+E9U4+_3Zc7gUQ0YEiah4t1LbQ@mail.gmail.com>
Date: Tue, 8 Jan 2013 19:23:17 -0800
Message-ID: <CAOesGMiEPc1wsv+_K-fPny7U128dcpv1c8cQHsovVoE_9XWiYg@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: arm-soc fixes for 3.8-rc
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 7:13 PM, Olof Johansson <olof@lixom.net> wrote:

> Or maybe a better solution is to make git request-pull throw an error
> if there is a local signed tag for the request, but none is found on
> the server (or has different contents). I'll take a look at that.

A-HA! Git does that as of 1.7.11.2 / 1.7.12, my version was just a
little too old.


-Olof
