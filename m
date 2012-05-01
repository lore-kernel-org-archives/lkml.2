Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2EAHfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 03:35:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2EAHfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 03:35:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120501160838.0bc75873705d84625d1fb98b@canb.auug.org.au>
References: <20120501160838.0bc75873705d84625d1fb98b@canb.auug.org.au>
Date: Tue, 1 May 2012 00:35:45 -0700
X-Google-Sender-Auth: WJqlOxo3PVRzLZ4mh0UxtF1c7io
Message-ID: <CAE9FiQXrohEJKx_4OAh-AXo9t9cySViDBG+kP-uTWhTKinaA6Q@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the pci tree
From: Yinghai Lu <yinghai@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b33da4c69104404bef49e95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b33da4c69104404bef49e95
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Apr 30, 2012 at 11:08 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Bjorn,
>
> After merging the pci tree, today's linux-next build (i386 defconfig)
> produced this warning:
>
> arch/x86/pci/amd_bus.c: In function 'early_fill_mp_bus_info':
> arch/x86/pci/amd_bus.c:56:6: warning: unused variable 'j' [-Wunused-variable]
>
> Introduced by commit d28e5ac2a07e ("x86/PCI: dynamically allocate
> pci_root_info for native host bridge drivers").
>

please check attached patch.

Thanks

Yinghai

--047d7b33da4c69104404bef49e95
Content-Type: application/octet-stream; name="amd_bus_warning.patch"
Content-Disposition: attachment; filename="amd_bus_warning.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1on75nl1

U3ViamVjdDogW1BBVENIXSBQQ0kveDg2OiBGaXggdW51c2VkIHdhcm5pbmcgd2l0aCBhbWRfYnVz
CgpIYXZlIHNlcGFyYXRlZCBmdW5jdGlvbiBmb3IgdGhhdC4KClJlcG9ydGVkLWJ5OiBTdGVwaGVu
IFJvdGh3ZWxsIDxzZnJAY2FuYi5hdXVnLm9yZy5hdT4KU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBM
dSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L3BjaS9hbWRfYnVz
LmMgYi9hcmNoL3g4Ni9wY2kvYW1kX2J1cy5jCmluZGV4IDQ1OWE3MzEuLjVhZWQ0OWIgMTAwNjQ0
Ci0tLSBhL2FyY2gveDg2L3BjaS9hbWRfYnVzLmMKKysrIGIvYXJjaC94ODYvcGNpL2FtZF9idXMu
YwpAQCAtNDQsNiArNDQsMTUgQEAgc3RhdGljIHN0cnVjdCBwY2lfcm9vdF9pbmZvIF9faW5pdCAq
ZmluZF9wY2lfcm9vdF9pbmZvKGludCBub2RlLCBpbnQgbGluaykKIAlyZXR1cm4gTlVMTDsKIH0K
IAorc3RhdGljIHZvaWQgX19pbml0IHNldF9tcF9idXNfcmFuZ2VfdG9fbm9kZShpbnQgbWluX2J1
cywgaW50IG1heF9idXMsIGludCBub2RlKQoreworI2lmZGVmIENPTkZJR19OVU1BCisJaW50IGo7
CisKKwlmb3IgKGogPSBtaW5fYnVzOyBqIDw9IG1heF9idXM7IGorKykKKwkJc2V0X21wX2J1c190
b19ub2RlKGosIG5vZGUpOworI2VuZGlmCit9CiAvKioKICAqIGVhcmx5X2ZpbGxfbXBfYnVzX3Rv
X25vZGUoKQogICogY2FsbGVkIGJlZm9yZSBwY2liaW9zX3NjYW5fcm9vdCBhbmQgcGNpX3NjYW5f
YnVzCkBAIC01Myw3ICs2Miw2IEBAIHN0YXRpYyBzdHJ1Y3QgcGNpX3Jvb3RfaW5mbyBfX2luaXQg
KmZpbmRfcGNpX3Jvb3RfaW5mbyhpbnQgbm9kZSwgaW50IGxpbmspCiBzdGF0aWMgaW50IF9faW5p
dCBlYXJseV9maWxsX21wX2J1c19pbmZvKHZvaWQpCiB7CiAJaW50IGk7Ci0JaW50IGo7CiAJdW5z
aWduZWQgYnVzOwogCXVuc2lnbmVkIHNsb3Q7CiAJaW50IG5vZGU7CkBAIC0xMDksMTAgKzExNyw3
IEBAIHN0YXRpYyBpbnQgX19pbml0IGVhcmx5X2ZpbGxfbXBfYnVzX2luZm8odm9pZCkKIAkJbWlu
X2J1cyA9IChyZWcgPj4gMTYpICYgMHhmZjsKIAkJbWF4X2J1cyA9IChyZWcgPj4gMjQpICYgMHhm
ZjsKIAkJbm9kZSA9IChyZWcgPj4gNCkgJiAweDA3OwotI2lmZGVmIENPTkZJR19OVU1BCi0JCWZv
ciAoaiA9IG1pbl9idXM7IGogPD0gbWF4X2J1czsgaisrKQotCQkJc2V0X21wX2J1c190b19ub2Rl
KGosIG5vZGUpOwotI2VuZGlmCisJCXNldF9tcF9idXNfcmFuZ2VfdG9fbm9kZShtaW5fYnVzLCBt
YXhfYnVzLCBub2RlKTsKIAkJbGluayA9IChyZWcgPj4gOCkgJiAweDAzOwogCiAJCWluZm8gPSBh
bGxvY19wY2lfcm9vdF9pbmZvKG1pbl9idXMsIG1heF9idXMsIG5vZGUsIGxpbmspOwo=
--047d7b33da4c69104404bef49e95--
