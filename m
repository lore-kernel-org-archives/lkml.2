Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2CWCQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:16:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39870 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2CWCQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120323020052.GA11519@redhat.com>
References: <20120323020052.GA11519@redhat.com>
Date: Thu, 22 Mar 2012 19:16:24 -0700
X-Google-Sender-Auth: MCpU17ZnLVf4PSTbdziB-aCsLns
Message-ID: <CAE9FiQVJo_Oik-EThFyLVu15ULOKRVzr7HtM03KxXz0D3_gpBQ@mail.gmail.com>
Subject: Re: excessive MSR print out during boot.
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Jones <davej@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        mingo@elte.hu, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b339d0f80a5f104bbdf9ccf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b339d0f80a5f104bbdf9ccf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 22, 2012 at 7:00 PM, Dave Jones <davej@redhat.com> wrote:
> During bootup, I now have 162 messages like this..
>
> [ =A0 =A00.227346] =A0MSR0000001b: 00000000fee00900
> [ =A0 =A00.227465] =A0MSR00000021: 0000000000000001
> [ =A0 =A00.227584] =A0MSR0000002a: 00000000c1c81400
>
> commit 21c3fcf3e39353d4f21d50e257cc74f3204b1988 looks suspect.
> It claims that it will only print these out if show_msr=3D is passed,
> but that doesn't seem to be the case.

sorry abut that.

please check attached patch.

Thanks

Yinghai

--047d7b339d0f80a5f104bbdf9ccf
Content-Type: text/x-patch; charset=US-ASCII; name="print_msr_fix_22.patch"
Content-Disposition: attachment; filename="print_msr_fix_22.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h04llsf90

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L2NvbW1vbi5jCmluZGV4IGFkZTljNzkuLmIyNDAzMjMgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9jcHUvY29tbW9uLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24u
YwpAQCAtOTk4LDcgKzk5OCw3IEBAIHZvaWQgX19jcHVpbml0IHByaW50X2NwdV9pbmZvKHN0cnVj
dCBjcHVpbmZvX3g4NiAqYykKIAllbHNlCiAJCXByaW50ayhLRVJOX0NPTlQgIlxuIik7CiAKLQlf
X3ByaW50X2NwdV9tc3IoKTsKKwlwcmludF9jcHVfbXNyKGMpOwogfQogCiB2b2lkIF9fY3B1aW5p
dCBwcmludF9jcHVfbXNyKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykK
--047d7b339d0f80a5f104bbdf9ccf--
