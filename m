Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0DNIcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 04:32:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0DNIco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 04:32:44 -0400
Date: Wed, 14 Apr 2010 01:32:37 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Jeff Mahoney <jeffm@suse.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Edward Shishkin <edward.shishkin@gmail.com>, stable@kernel.org,
       kernel@jbeekman.nl, gregsurbey@hotmail.com,
       Marco Gatti <marco.gatti@gmail.com>
Subject: Re: [PATCH] reiserfs: Fix corruption during shrinking of xattrs
In-Reply-To: <4BC4C888.9040104@suse.com>
Message-ID: <alpine.DEB.2.01.1004140127090.29272@bogon.housecafe.de>
References: <4BC4C888.9040104@suse.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463809526-313401583-1271233957=:29272"
X-Provags-ID: V01U2FsdGVkX1+F8l1Xee8o46APSeoLrMb5bLiLQSAawNuzQwn
 pImjtvy769VkkFsb64ocTuR+A4vqE3ccJb/s+Gb8N4lcEIL2dI
 JCz8fzVVrn2x/sOtPylwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463809526-313401583-1271233957=:29272
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Tue, 13 Apr 2010 at 15:39, Jeff Mahoney wrote:
>  This patch fixes it to use new_size.

Tested-by: Christian Kujau <lists@nerdbynature.de>

With this patch applied (to today's mainline git, 2.6.34-rc4) I was able 
to create 30k files with xattrs on the same test system that was failing 
to do so before.

Thanks for the fix!

Christian.
-- 
BOFH excuse #88:

Boss' kid fucked up the machine
---1463809526-313401583-1271233957=:29272
Content-Type: TEXT/x-diff; name=reiserfs-xattr_rc4.diff
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.01.1004140132370.29272@bogon.housecafe.de>
Content-Description: 
Content-Disposition: attachment; filename=reiserfs-xattr_rc4.diff

ZGlmZiAtLWdpdCBhL2ZzL3JlaXNlcmZzL3hhdHRyLmMgYi9mcy9yZWlzZXJm
cy94YXR0ci5jDQppbmRleCA0Zjk1ODZiLi4yMDU4YzI4IDEwMDY0NA0KLS0t
IGEvZnMvcmVpc2VyZnMveGF0dHIuYw0KKysrIGIvZnMvcmVpc2VyZnMveGF0
dHIuYw0KQEAgLTU1NCw3ICs1NTQsNyBAQCByZWlzZXJmc194YXR0cl9zZXRf
aGFuZGxlKHN0cnVjdCByZWlzZXJmc190cmFuc2FjdGlvbl9oYW5kbGUgKnRo
LA0KIAlpZiAoIWVyciAmJiBuZXdfc2l6ZSA8IGlfc2l6ZV9yZWFkKGRlbnRy
eS0+ZF9pbm9kZSkpIHsNCiAJCXN0cnVjdCBpYXR0ciBuZXdhdHRycyA9IHsN
CiAJCQkuaWFfY3RpbWUgPSBjdXJyZW50X2ZzX3RpbWUoaW5vZGUtPmlfc2Ip
LA0KLQkJCS5pYV9zaXplID0gYnVmZmVyX3NpemUsDQorCQkJLmlhX3NpemUg
PSBuZXdfc2l6ZSwNCiAJCQkuaWFfdmFsaWQgPSBBVFRSX1NJWkUgfCBBVFRS
X0NUSU1FLA0KIAkJfTsNCiANCg==

---1463809526-313401583-1271233957=:29272--
