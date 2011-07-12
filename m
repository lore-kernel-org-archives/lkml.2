Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1GLSPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:15:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36652 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab1GLSPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:15:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAFziu1HvspbMj8LRLHd2w9vcVq_mGCL3pCOwLaduKQ4nt8+Utg@mail.gmail.com>
References: <CACqU3MW=VUn64nsSA2V_eXEfEjv6xmB9yBWL8rYynH1wkHcOgw@mail.gmail.com>
	<1310454020-15426-1-git-send-email-abogani@kernel.org>
	<CAFziu1HvspbMj8LRLHd2w9vcVq_mGCL3pCOwLaduKQ4nt8+Utg@mail.gmail.com>
Date: Tue, 12 Jul 2011 14:15:39 -0400
Message-ID: <CACqU3MVZ6UPZKSsSSjZosTYfbzuwj_dCumK-wcb_SWhs+8OgNQ@mail.gmail.com>
Subject: Re: [PATCH] modpost: Fix modpost's license checking V2
From: Arnaud Lacombe <lacombar@gmail.com>
To: Anders Kaseorg <andersk@ksplice.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 12, 2011 at 2:02 PM, Anders Kaseorg <andersk@ksplice.com> wrote:
> On Tue, Jul 12, 2011 at 03:00, Alessio Igor Bogani <abogani@kernel.org> wrote:
>> +#define SEC_NAME_MATCH(name, str) (strncmp(name, str, strlen(str) - 1) == 0)
>
> Surely you meant strlen() or sizeof() - 1, not strlen() - 1?
>
>> +       if (!is_vmlinux(mod->name) && strncmp(symname, "__ksymtab", 9) == 0)
>
> Same strncmp pattern here.  BTW, your macro is the strstarts()
> function in include/linux/string.h.
>
modpost is an host tool, it should not include kernel header. Content
of this file is not exported to userland anyway.

 - Arnaud

 - Arnaud
