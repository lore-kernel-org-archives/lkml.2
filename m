Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935733Ab2JaPa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:30:28 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57544 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2JaPa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:30:27 -0400
MIME-Version: 1.0
In-Reply-To: <50911F67.3040303@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
 <1350592007-9216-22-git-send-email-jslaby@suse.cz> <50897E98.5080502@gmail.com>
 <50911F67.3040303@suse.cz>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 31 Oct 2012 11:30:06 -0400
Message-ID: <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 8:53 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 10/25/2012 08:02 PM, Sasha Levin wrote:
>> Fuzzing with trinity inside a KVM tools (lkvm) guest with -next kernel
>> uncovered the following warning:
>
> I cannot reproduce that :(. Do you still see it?

Yes, it reproduces pretty easily while fuzzing.


Thanks,
Sasha
