Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0HSPT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:19:57 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:43198 "EHLO
	mail.bspu.unibel.by" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab0HSPTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:19:53 -0400
X-Greylist: delayed 1270 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Aug 2010 11:19:52 EDT
Message-ID: <4C6D469F.2080900@bspu.unibel.by>
Date: Thu, 19 Aug 2010 17:58:39 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ru; rv:1.9.3a6pre) Gecko/20100804 SeaMonkey/2.1a2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: #3 (Re: More modaliases + patchtool)
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au>
In-Reply-To: <201008191020.52861.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------030408020005070804070604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030408020005070804070604
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rusty Russell пишет:

> Finally, I suggest that your script should only fix files when passed --fix,
> and create a config option to run it (without --fix) under in
> lib/Kconfig.debug.

This is fixed script and patch for lib/Kconfig.debug & Makefile.
I am unsure in patch (mostly Makefile inclusions) - FIXME.
For example, I unsure in "PHONY += check_modaliases" requirement (and sense).

Also may be suggested negative exitcode to strict check. (?)

-- 
WBR, Dzianis Kahanovich AKA Denis Kaganovich, http://mahatma.bspu.unibel.by/


--------------030408020005070804070604
Content-Type: text/plain;
 name="modulesfix"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="modulesfix"

IyEvYmluL2Jhc2gKIyMgKGMpIERlbmlzIEthZ2Fub3ZpY2gKIyMgdjUKIyMgZ3JlcC1wY3Jl
IHJlcXVpcmVkCgojQlVTPSJwY2kiCkJVUz0iXHcrIgoKU1RSPSJeKD86c3RhdGljXHMrKT8o
Pzpjb25zdFxzKyk/c3RydWN0XHMrIgoKZm5kKCl7CmxvY2FsIG1zZz0iRml4aW5nOiIKJGZp
eCB8fCBtc2c9Ik5lZWQgdG8gZml4OiIKZ3JlcCAtUHJobCAiJHtTVFJ9JHtCVVN9X2Rldmlj
ZV9pZFxzKyIgJDEgLS1pbmNsdWRlPSIqLmMiIHwgd2hpbGUgcmVhZCBpIDsgZG8KCWxvY2Fs
IGJ1cz1gZ3JlcCAtUHJobyAiJHtTVFJ9JHtCVVN9X2RldmljZV9pZC4qXHMrIiAkaWAKCWJ1
cz0iJHtidXMjKnN0cnVjdCB9IgoJbG9jYWwgbj0iJHtidXMlJVsqfSIKCW49IiR7biUlPSp9
IgoJbj0iJHtuIyMqZGV2aWNlX2lkIH0iCgluPSIke24vLyB9IgoJYnVzPSIke2J1cyUlX2Rl
dmljZV9pZCp9IgoJZ3JlcCAtUHEgIl5tb2R1bGVfaW5pdFxzKlwoIiAkaSB8fCBjb250aW51
ZQoJZ3JlcCAtcSAiTU9EVUxFX0RFVklDRV9UQUJMRSIgJGkgJiYgY29udGludWUKCWxvY2Fs
IGlpPSIke2kjJDF9IgoJaWk9IiR7aWkjL30iCgojCWNhc2UgJGlpIGluCiMJKi9tZGlvLWdw
aW8uYykKIwkJZWNobyAiQlJPS0VOOiAkYnVzOiAkaWkiCiMJCWNvbnRpbnVlCiMJOzsKIwll
c2FjCgoJYnVzPSIke2J1cyUlXyp9IgoJbG9jYWwgQlUKCWNhc2UgIiRidXMiIGluCglzZGlv
KUJVPU1NQzs7CgkqKUJVPSIke2J1c15efSI7OwoJZXNhYwoJaWYgZ3JlcCAtUHJxICJeXHMq
KD86bWVudSk/Y29uZmlnXHMrJEJVKD86XHMuKik/JCIgJDEgLS1pbmNsdWRlPSJLY29uZmln
KiI7IHRoZW4KCQllY2hvICIkbXNnICRCVTogKCRuKSAkaWkiCgkJJGZpeCAmJiBzZWQgLWkg
LWUgJ3MvXlwobW9kdWxlX2luaXQuKlwpJC9cbiNpZmRlZiBDT05GSUdfJyIkQlUiJ1xuTU9E
VUxFX0RFVklDRV9UQUJMRSgnIiRidXMsICRuIicpO1xuI2VuZGlmXG5cblwxLycgJGkKCWVs
c2UKCQllY2hvICIkbXNnICRidXM6ICgkbikgJGlpIgoJCSRmaXggJiYgc2VkIC1pIC1lICdz
L15cKG1vZHVsZV9pbml0LipcKSQvXG5NT0RVTEVfREVWSUNFX1RBQkxFKCciJGJ1cywgJG4i
Jyk7XG5cblwxLycgJGkKCWZpCmRvbmUKfQoKcD0iIgpmaXg9ZmFsc2UKd2hpbGUgW1sgLW4g
IiQqIiBdXTsgZG8KCWNhc2UgIiQxIiBpbgoJLS1maXgpZml4PXRydWU7OwoJKilwPSIkcCAk
MSI7OwoJZXNhYwoJc2hpZnQKZG9uZQpbWyAteiAiJHAiIF1dICYmIGVjaG8gIiQwIFstLWZp
eF0gPHBhdGhfdG9fa2VybmVsPgooZ3JlcCtwY3JlIHJlcXVpcmVkKSIgJiYgZXhpdCAxCgpm
bmQgJHAK
--------------030408020005070804070604
Content-Type: text/plain;
 name="modulesfix_config.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="modulesfix_config.patch"

UnVuICJzY3JpcHRzL21vZHVsZXNmaXgiIGlmIENPTkZJR19DSEVDS19NT0RVTEVfREVWSUNF
X1RBQkxFLgoKU2lnbmVkLW9mZi1ieTogRHppYW5pcyBLYWhhbm92aWNoIDxtYWhhdG1hQGV1
LmJ5PgoKZGlmZiAtcHJ1TiBiL2xpYi9LY29uZmlnLmRlYnVnIGMvbGliL0tjb25maWcuZGVi
dWcKLS0tIGIvbGliL0tjb25maWcuZGVidWcJMjAxMC0wOC0xOSAxNToyMDo1OC4wMDAwMDAw
MDAgKzAzMDAKKysrIGMvbGliL0tjb25maWcuZGVidWcJMjAxMC0wOC0xOSAxNzozMzoxMi41
OTQ3NjQ5NTQgKzAzMDAKQEAgLTExNDcsNiArMTE0NywxMyBAQCBjb25maWcgQVRPTUlDNjRf
U0VMRlRFU1QKIAogCSAgSWYgdW5zdXJlLCBzYXkgTi4KIAorY29uZmlnIENIRUNLX01PRFVM
RV9ERVZJQ0VfVEFCTEUKKwlib29sICJQZXJmb3JtIGNoZWNrIE1PRFVMRV9ERVZJQ0VfVEFC
TEUgaW4gbW9kdWxlcyIKKwloZWxwCisJICBFbmFibGUgdGhpcyBvcHRpb24gdG8gY2hlY2sg
TU9EVUxFX0RFVklDRV9UQUJMRSBpbiBtb2R1bGVzLgorCSAgU29tZSBvZiBuZXcgbW9kdWxl
cyBzb21ldGltZXMgaGF2ZSBubyBNT0RVTEVfREVWSUNFX1RBQkxFIGRlY2xhcmF0aW9uCisJ
ICBhbmQgZG8gbm90IGV4cG9ydCBoYXJkd2FyZSBtb2R1bGUgYWxpYXMuIFNheSBZIHRvIGZp
bmQgdGhpcyBtb2R1bGVzLgorCiBzb3VyY2UgInNhbXBsZXMvS2NvbmZpZyIKIAogc291cmNl
ICJsaWIvS2NvbmZpZy5rZ2RiIgpkaWZmIC1wcnVOIGIvTWFrZWZpbGUgYy9NYWtlZmlsZQot
LS0gYi9NYWtlZmlsZQkyMDEwLTA4LTE5IDE1OjIwOjU4LjAwMDAwMDAwMCArMDMwMAorKysg
Yy9NYWtlZmlsZQkyMDEwLTA4LTE5IDE3OjQzOjA1LjA0NDc2NDk4NyArMDMwMApAQCAtODc0
LDYgKzg3NCwxMyBAQCBpZmRlZiBDT05GSUdfS0FMTFNZTVMKIC50bXBfdm1saW51eDE6IHZt
bGludXgubwogZW5kaWYKIAoraWZkZWYgQ09ORklHX0NIRUNLX01PRFVMRV9ERVZJQ0VfVEFC
TEUKK2NoZWNrX21vZGFsaWFzZXM6CisJJChzcmN0cmVlKS9zY3JpcHRzL21vZHVsZXNmaXgg
JChzcmN0cmVlKQorZWxzZQorY2hlY2tfbW9kYWxpYXNlczoKK2VuZGlmCisKIG1vZHBvc3Qt
aW5pdCA6PSAkKGZpbHRlci1vdXQgaW5pdC9idWlsdC1pbi5vLCAkKHZtbGludXgtaW5pdCkp
CiB2bWxpbnV4Lm86ICQobW9kcG9zdC1pbml0KSAkKHZtbGludXgtbWFpbikgRk9SQ0UKIAkk
KGNhbGwgaWZfY2hhbmdlZF9ydWxlLHZtbGludXgtbW9kcG9zdCkKQEAgLTEwMzQsNyArMTA0
MSw3IEBAIGFsbDogbW9kdWxlcwogIwl1c2luZyBhd2sgd2hpbGUgY29uY2F0ZW5hdGluZyB0
byB0aGUgZmluYWwgZmlsZS4KIAogUEhPTlkgKz0gbW9kdWxlcwotbW9kdWxlczogJCh2bWxp
bnV4LWRpcnMpICQoaWYgJChLQlVJTERfQlVJTFRJTiksdm1saW51eCkgbW9kdWxlcy5idWls
dGluCittb2R1bGVzOiAkKHZtbGludXgtZGlycykgJChpZiAkKEtCVUlMRF9CVUlMVElOKSx2
bWxpbnV4KSBtb2R1bGVzLmJ1aWx0aW4gY2hlY2tfbW9kYWxpYXNlcwogCSQoUSkkKEFXSykg
JyF4WyQkMF0rKycgJCh2bWxpbnV4LWRpcnM6JT0kKG9ianRyZWUpLyUvbW9kdWxlcy5vcmRl
cikgPiAkKG9ianRyZWUpL21vZHVsZXMub3JkZXIKIAlAJChrZWNobykgJyAgQnVpbGRpbmcg
bW9kdWxlcywgc3RhZ2UgMi4nOwogCSQoUSkkKE1BS0UpIC1mICQoc3JjdHJlZSkvc2NyaXB0
cy9NYWtlZmlsZS5tb2Rwb3N0Cg==
--------------030408020005070804070604--
