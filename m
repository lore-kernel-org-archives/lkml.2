Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2LEKy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:54:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab2LEKyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:54:25 -0500
Message-ID: <50BF27D5.6050606@suse.cz>
Date: Wed, 05 Dec 2012 11:54:13 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>, Rusty Russell <rusty@ozlabs.org>,
        linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 2/3] MODSIGN: Avoid using .incbin in C source
References: <s5hobi9aqxs.wl%tiwai@suse.de> <1354616321-13520-2-git-send-email-mmarek@suse.cz> <1354616321-13520-1-git-send-email-mmarek@suse.cz> <22396.1354645048@warthog.procyon.org.uk> <87hao1gyiv.fsf@rustcorp.com.au> <6935.1354703447@warthog.procyon.org.uk>
In-Reply-To: <6935.1354703447@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 5.12.2012 11:30, David Howells napsal(a):
> Takashi Iwai <tiwai@suse.de> wrote:
> 
>> +#ifndef SYMBOL_PREFIX
> 
> This comes via the command line?

Yes, see scripts/Makefile.lib:

ifdef CONFIG_SYMBOL_PREFIX
_sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
_cpp_flags += $(_sym_flags)
_a_flags += $(_sym_flags)
endif

Michal
