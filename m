Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485Ab2JaPcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:32:35 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43676 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2JaPce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:32:34 -0400
Message-ID: <5091448D.3@suse.cz>
Date: Wed, 31 Oct 2012 16:32:29 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz> <1350592007-9216-22-git-send-email-jslaby@suse.cz> <50897E98.5080502@gmail.com> <50911F67.3040303@suse.cz> <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com>
In-Reply-To: <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 04:30 PM, Sasha Levin wrote:
> On Wed, Oct 31, 2012 at 8:53 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 10/25/2012 08:02 PM, Sasha Levin wrote:
>>> Fuzzing with trinity inside a KVM tools (lkvm) guest with -next kernel
>>> uncovered the following warning:
>>
>> I cannot reproduce that :(. Do you still see it?
> 
> Yes, it reproduces pretty easily while fuzzing.

What is your exact setup? I tried trinity with 100 000 syscalls inside
KVM with an LDEP-enabled kernel. How many serial ports do you have in
the guest? Any USB serials in there?

-- 
js
suse labs
