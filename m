Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1CVLEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:04:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34931 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab1CVLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:04:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: [patch 0/5] oom: a few anti fork bomb patches
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110315153801.3526.A69D9226@jp.fujitsu.com>
References: <20110314232156.0c363813.akpm@linux-foundation.org> <20110315153801.3526.A69D9226@jp.fujitsu.com>
Message-Id: <20110322194721.B05E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------_4D887E3900000000B05A_MULTIPART_MIXED_"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 22 Mar 2011 20:04:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------_4D887E3900000000B05A_MULTIPART_MIXED_
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Hi

I'm backed. Andrey's (attached) fork bomb testcase effectively kill
my machine when swap is disabled. therefore, I've made a few anti andrey
test patches.

This patches only avoid kernel livelock. they doesn't genocide fork-bombs.
Kamezawa-san is trying such effort.

comments are welcome.

--------_4D887E3900000000B05A_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="memeater.py"
Content-Disposition: attachment;
 filename="memeater.py"
Content-Transfer-Encoding: base64

aW1wb3J0IHN5cywgdGltZSwgbW1hcCwgb3MNCmZyb20gc3VicHJvY2VzcyBpbXBvcnQgUG9wZW4s
IFBJUEUNCmltcG9ydCByYW5kb20NCg0KZ2xvYmFsIG1lbV9zaXplDQoNCmRlZiBpbmZvKG1zZyk6
DQoJcGlkID0gb3MuZ2V0cGlkKCkNCglwcmludCA+PiBzeXMuc3RkZXJyLCAiJXM6ICVzIiAlIChw
aWQsIG1zZykNCglzeXMuc3RkZXJyLmZsdXNoKCkNCg0KDQoNCmRlZiBtZW1vcnlfbG9vcChjbWQg
PSAiYSIpOg0KCSIiIg0KCWNtZCBtYXkgYmU6DQoJCWM6IGNoZWNrIG1lbW9yeQ0KCQllbHNlOiB0
b3VjaCBtZW1vcnkNCgkiIiINCgljID0gMA0KCWZvciBqIGluIHhyYW5nZSgwLCBtZW1fc2l6ZSk6
DQoJCWlmIGNtZCA9PSAiYyI6DQoJCQlpZiBmW2o8PDEyXSAhPSBjaHIoaiAlIDI1NSk6DQoJCQkJ
aW5mbygiRGF0YSBjb3JydXB0aW9uIikNCgkJCQlzeXMuZXhpdCgxKQ0KCQllbHNlOg0KCQkJZltq
PDwxMl0gPSBjaHIoaiAlIDI1NSkNCg0Kd2hpbGUgVHJ1ZToNCglwaWQgPSBvcy5mb3JrKCkNCglp
ZiAocGlkICE9IDApOg0KCQltZW1fc2l6ZSA9IHJhbmRvbS5yYW5kaW50KDAsIDU2ICogNDA5NikN
CgkJZiA9IG1tYXAubW1hcCgtMSwgbWVtX3NpemUgPDwgMTIsIG1tYXAuTUFQX0FOT05ZTU9VU3xt
bWFwLk1BUF9QUklWQVRFKQ0KCQltZW1vcnlfbG9vcCgpDQoJCW1lbW9yeV9sb29wKCJjIikNCgkJ
Zi5jbG9zZSgpDQo=
--------_4D887E3900000000B05A_MULTIPART_MIXED_--


