Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2LGWqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:46:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42795 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab2LGWqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:46:11 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1354920151-4461-1-git-send-email-dinggnu@gmail.com>
References: <1354920151-4461-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] arch/x86/tools/gen-insn-attr-x86.awk: remove duplicate const
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 07 Dec 2012 14:45:43 -0800
To: Cong Ding <dinggnu@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Message-ID: <3c1e54bc-31ec-4a38-b6d3-58b25760f9cb@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch description please?

Cong Ding <dinggnu@gmail.com> wrote:

>
>Signed-off-by: Cong Ding <dinggnu@gmail.com>
>---
> arch/x86/tools/gen-insn-attr-x86.awk |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/tools/gen-insn-attr-x86.awk
>b/arch/x86/tools/gen-insn-attr-x86.awk
>index ddcf39b..d1d9cfa 100644
>--- a/arch/x86/tools/gen-insn-attr-x86.awk
>+++ b/arch/x86/tools/gen-insn-attr-x86.awk
>@@ -356,7 +356,7 @@ END {
> 		exit 1
> 	# print escape opcode map's array
> 	print "/* Escape opcode map array */"
>-	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1]"
>\
>+	print "const insn_attr_t *inat_escape_tables[INAT_ESC_MAX + 1]" \
> 	      "[INAT_LSTPFX_MAX + 1] = {"
> 	for (i = 0; i < geid; i++)
> 		for (j = 0; j < max_lprefix; j++)
>@@ -365,7 +365,7 @@ END {
> 	print "};\n"
> 	# print group opcode map's array
> 	print "/* Group opcode map array */"
>-	print "const insn_attr_t const *inat_group_tables[INAT_GRP_MAX + 1]"\
>+	print "const insn_attr_t *inat_group_tables[INAT_GRP_MAX + 1]"\
> 	      "[INAT_LSTPFX_MAX + 1] = {"
> 	for (i = 0; i < ggid; i++)
> 		for (j = 0; j < max_lprefix; j++)

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
