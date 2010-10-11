Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0JKI5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0JKI5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:57:37 -0400
Message-ID: <4CB2D17A.4000605@redhat.com>
Date: Mon, 11 Oct 2010 10:57:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: Re: [PATCH trace-cmd] plugin_kvm: remove stray line from kvm_emulate_insn_handler()
References: <1285493922-29797-1-git-send-email-avi@redhat.com>
In-Reply-To: <1285493922-29797-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/26/2010 11:38 AM, Avi Kivity wrote:
> 'guest_rip' is not part of kvm_emulate_insn.
>
> Signed-off-by: Avi Kivity<avi@redhat.com>
> ---
>   plugin_kvm.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/plugin_kvm.c b/plugin_kvm.c
> index 00cac5a..cdd52c7 100644
> --- a/plugin_kvm.c
> +++ b/plugin_kvm.c
> @@ -199,8 +199,6 @@ static int kvm_emulate_insn_handler(struct trace_seq *s, struct record *record,
>   	trace_seq_printf(s, "%llx:%llx: %s%s", csbase, rip, disasm,
>   			 failed ? " FAIL" : "");
>
> -	pevent_print_num_field(s, " rip %0xlx", event, "guest_rip", record, 1);
> -
>   	return 0;
>   }
>

Ping?

-- 
error compiling committee.c: too many arguments to function

