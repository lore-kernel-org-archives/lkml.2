Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab2FFRzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:55:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab2FFRzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:55:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120606095102.GH9495@gmail.com>
References: <20120601155447.GG3671@sgi.com>
	<CAE9FiQWJR6x4_Xhc2k5TFkCj2u5cpbcWf-jFWOB5pEuBQcoJrQ@mail.gmail.com>
	<20120604100700.GA4948@sgi.com>
	<CAE9FiQW_yBZZKsVt5Fy7QEqa7hBXhfbka4Ubh=oz4hDOzLQ0mg@mail.gmail.com>
	<20120606094211.GL4948@sgi.com>
	<20120606094804.GM4948@sgi.com>
	<20120606095102.GH9495@gmail.com>
Date: Wed, 6 Jun 2012 10:55:40 -0700
X-Google-Sender-Auth: 7zldoUNFgQL8tcEYjM7gqo8l9EY
Message-ID: <CAE9FiQUj3wyzQxtq9yzBNc9u220p8JZ1FYHG7t=MOzJ=9BZMYA@mail.gmail.com>
Subject: Re: Commit 722bc6b167 breaks booting on an 8TB system.
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, WANG Cong <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary=047d7b2ee03fb5303304c1d17965
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b2ee03fb5303304c1d17965
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 6, 2012 at 2:51 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Robin Holt <holt@sgi.com> wrote:
>>
>> Wait. =A0I was wrong. =A0I booted the wrong kernel. =A0With that
>> patch applied, the machine does boot.
>
> Great.
>
> Could you guys please write a usable changelog for
> only_need_recalculate_for_low.patch and send it to me with lkml
> Cc:-ed, so that I can send the fix to Linus ASAP?

please check attached one.

Thanks

Yinghai

--047d7b2ee03fb5303304c1d17965
Content-Type: application/octet-stream; 
	name="only_need_recalculate_for_low_v2.patch"
Content-Disposition: attachment; 
	filename="only_need_recalculate_for_low_v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h34p77pe0

U3ViamVjdDogW1BBVENIXSB4ODY6IE9ubHkgYWRkIGV4dHJhIHBhZ2VzIGNvdW50IGZvciBmaXJz
dCBtZW1vcnkgcmFuZ2UgZHVyaW5nIHByZS1hbGxvY2F0ZSBlYXJseSBwYWdlIHRhYmxlIHNwYWNl
CgpSb2JpbiBmb3VuZDoKfCBJIGp1c3QgdHJpZWQgdG8gYm9vdCBhbiA4VEIgc3lzdGVtLiAgSXQg
ZmFpbHMgdmVyeSBlYXJseSBpbiBib290IHdpdGg6CnwKfCBLZXJuZWwgcGFuaWMgLSBub3Qgc3lu
Y2luZzogQ2Fubm90IGZpbmQgc3BhY2UgZm9yIHRoZSBrZXJuZWwgcGFnZSB0YWJsZXMKCmdpdCBi
aXNlY3QgY29tbWl0IDcyMmJjNmIxNjc3MWVkODA4NzFlMWZkODFjODZkMzYyN2RkYTJhYzguCkEg
Z2l0IHJldmVydCBvZiB0aGF0IGNvbW1pdCBkb2VzIGJvb3QgcGFzdCB0aGF0IHBvaW50IG9uIHRo
ZSA4VEIgY29uZmlndXJhdGlvbi4KClRoYXQgY29tbWl0IHdpbGwgYWRkIHVwIGV4dHJhIHBhZ2Vz
IGZvciBhbGwgbWVtb3J5IHJhbmdlIGV2ZW4gYWJvdmUgNGcuCgpUcnkgdG8gbGltaXQgdGhhdCBl
eHRyYSBwYWdlIGNvdW50IGFkZGluZyB0byBmaXJzdCBlbnRyeSBvbmx5LgoKQmlzZWN0ZWQtYnk6
IFJvYmluIEhvbHQgPGhvbHRAc2dpLmNvbT4KVGVzdGVkLWJ5OiBSb2JpbiBIb2x0IDxob2x0QHNn
aS5jb20+ClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0t
LQogYXJjaC94ODYvbW0vaW5pdC5jIHwgICAgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvbW0vaW5p
dC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L21tL2luaXQuYworKysg
bGludXgtMi42L2FyY2gveDg2L21tL2luaXQuYwpAQCAtNjIsNyArNjIsOCBAQCBzdGF0aWMgdm9p
ZCBfX2luaXQgZmluZF9lYXJseV90YWJsZV9zcGFjCiAJCWV4dHJhICs9IFBNRF9TSVpFOwogI2Vu
ZGlmCiAJCS8qIFRoZSBmaXJzdCAyLzRNIGRvZXNuJ3QgdXNlIGxhcmdlIHBhZ2VzLiAqLwotCQll
eHRyYSArPSBtci0+ZW5kIC0gbXItPnN0YXJ0OworCQlpZiAobXItPnN0YXJ0IDwgUE1EX1NJWkUp
CisJCQlleHRyYSArPSBtci0+ZW5kIC0gbXItPnN0YXJ0OwogCiAJCXB0ZXMgPSAoZXh0cmEgKyBQ
QUdFX1NJWkUgLSAxKSA+PiBQQUdFX1NISUZUOwogCX0gZWxzZQo=
--047d7b2ee03fb5303304c1d17965--
