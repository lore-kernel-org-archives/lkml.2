Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab2AKF6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 00:58:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64493 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2AKF6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 00:58:33 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1201091252220.18816@tundra.namei.org>
References: <alpine.LRH.2.00.1201091252220.18816@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 21:58:11 -0800
X-Google-Sender-Auth: UBqIF6VUNENiBx862XWvnqT_T-c
Message-ID: <CA+55aFwD2-bhd32L1SsjPQrpwOBhBdxTUaOj=oXN24vPwc+Wsg@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.3
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 6:22 PM, James Morris <jmorris@namei.org> wrote:
> The most significant change here is the addition of the digital signature
> verification API, for use by IMA, EVM and module loading.  The rest is
> general maintenance.

Hmm. The CONFIG_MPI/DIGSIG thing really should go away as a question,
I think. I'd expect modules that need it to select it, there's no
point in asking a user "do you want this enabled" afaik.

And "DIGSIG" is really a horrible config name. Did somebody run out of
letters suddenly? Is there some global letter shortage that I haven't
been told of and that we should do something about?

But I pulled it. Please do fix it up, though.

                    Linus
