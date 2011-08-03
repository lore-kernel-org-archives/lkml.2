Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1HCVr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:47:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63828 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab1HCVrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:47:20 -0400
MIME-Version: 1.0
In-Reply-To: <CANYdXnpBx8fBJABhg5Yt45fmo3MSVGAvn72AThOUAwgVeKZTEw@mail.gmail.com>
References: <CANYdXnoK5bRv8wZj2zhQaF=_ok1b2jo1Pwg8N4aFmJ5hk5fAZQ@mail.gmail.com>
	<CANYdXnpBx8fBJABhg5Yt45fmo3MSVGAvn72AThOUAwgVeKZTEw@mail.gmail.com>
Date: Wed, 3 Aug 2011 22:47:19 +0100
Message-ID: <CAAVPGONvJThfOrvXHT-vOFns7-QuCLMoMk3NjzAbRYiqRQNU-w@mail.gmail.com>
Subject: Re: A question on selection of source tree for patch submission
From: Julie Sullivan <kernelmail.jms@gmail.com>
To: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   For the Kernel patch submission, Should I clone the source from
> mainline or the linux-next tree ?

You mean for generally submitting or testing patches? I'd clone mainline

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

and then remote track linux-next (or any other branch a specific
maintainer would want you to test against, this depends on what your
patch is for).

Cheers
Julie
