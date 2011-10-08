Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab1JHNCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 09:02:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab1JHNCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 09:02:45 -0400
MIME-Version: 1.0
Date: Sat, 8 Oct 2011 21:02:44 +0800
Message-ID: <CAM_iQpUgC8Enwm9FWYmc9uLvzjYNgXz8WKxBGeZTw3XL8f24eg@mail.gmail.com>
Subject: [PATCH] MAINTAINERS: update pm list address
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
        "Len Brown (Intel)" <len.brown@intel.com>,
        Paul Walmsley <paul@pwsan.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Jean Pihet <jean.pihet@newoldbits.com>, Kevin Hilman <khilman@ti.com>,
        magnus.damm@gmail.com, Bojan Smojver <bojan@rexursive.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>, tom.leiming@gmail.com,
        Linux PM <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>, Pavel Machek <pavel@ucw.cz>
Content-Type: multipart/mixed; boundary=00151773ea2c7a7cc104aec92c6c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151773ea2c7a7cc104aec92c6c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 8, 2011 at 4:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> Due to the continuing outage of lists.linux-foundation.org the linux-pm
> mailing list is going to be hosted at vger.kernel.org from now on. =C2=A0=
The
> new address of the list is linux-pm@vger.kernel.org .
>

Hi, Rafael,

I think the following patch is needed. :)

----

Change the pm list address in MAINTAINERS, as it is moved to
vger.kernel.org now.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

--00151773ea2c7a7cc104aec92c6c
Content-Type: text/x-patch; charset=US-ASCII; name="maintainer-change-pm-list-address.diff"
Content-Disposition: attachment; 
	filename="maintainer-change-pm-list-address.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtim5rw90

ZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMKaW5kZXggYWNlOGY5Yy4uMTc3
NGI2OCAxMDA2NDQKLS0tIGEvTUFJTlRBSU5FUlMKKysrIGIvTUFJTlRBSU5FUlMKQEAgLTI3MzMs
NyArMjczMyw3IEBAIEY6CWZzL2ZyZWV2eGZzLwogRlJFRVpFUgogTToJUGF2ZWwgTWFjaGVrIDxw
YXZlbEB1Y3cuY3o+CiBNOgkiUmFmYWVsIEouIFd5c29ja2kiIDxyandAc2lzay5wbD4KLUw6CWxp
bnV4LXBtQGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnCitMOglsaW51eC1wbUB2Z2VyLmtlcm5l
bC5vcmcKIFM6CVN1cHBvcnRlZAogRjoJRG9jdW1lbnRhdGlvbi9wb3dlci9mcmVlemluZy1vZi10
YXNrcy50eHQKIEY6CWluY2x1ZGUvbGludXgvZnJlZXplci5oCkBAIC0yOTk1LDcgKzI5OTUsNyBA
QCBGOglkcml2ZXJzL3ZpZGVvL2hnYWZiLmMKIEhJQkVSTkFUSU9OIChha2EgU29mdHdhcmUgU3Vz
cGVuZCwgYWthIHN3c3VzcCkKIE06CVBhdmVsIE1hY2hlayA8cGF2ZWxAdWN3LmN6PgogTToJIlJh
ZmFlbCBKLiBXeXNvY2tpIiA8cmp3QHNpc2sucGw+Ci1MOglsaW51eC1wbUBsaXN0cy5saW51eC1m
b3VuZGF0aW9uLm9yZworTDoJbGludXgtcG1Admdlci5rZXJuZWwub3JnCiBTOglTdXBwb3J0ZWQK
IEY6CWFyY2gveDg2L3Bvd2VyLwogRjoJZHJpdmVycy9iYXNlL3Bvd2VyLwpAQCAtMzE4OSw3ICsz
MTg5LDcgQEAgRjoJZHJpdmVycy9pZGUvaWRlLWNkKgogCiBJRExFLUk3MzAwCiBNOglBbmR5IEhl
bnJvaWQgPGFuZHJldy5kLmhlbnJvaWRAaW50ZWwuY29tPgotTDoJbGludXgtcG1AbGlzdHMubGlu
dXgtZm91bmRhdGlvbi5vcmcKK0w6CWxpbnV4LXBtQHZnZXIua2VybmVsLm9yZwogUzoJU3VwcG9y
dGVkCiBGOglkcml2ZXJzL2lkbGUvaTczMDBfaWRsZS5jCiAKQEAgLTMyNzIsNyArMzI3Miw3IEBA
IEY6CWZpcm13YXJlL2lzY2kvCiAKIElOVEVMIElETEUgRFJJVkVSCiBNOglMZW4gQnJvd24gPGxl
bmJAa2VybmVsLm9yZz4KLUw6CWxpbnV4LXBtQGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnCitM
OglsaW51eC1wbUB2Z2VyLmtlcm5lbC5vcmcKIFQ6CWdpdCBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbGVuYi9saW51eC1pZGxlLTIuNi5naXQKIFM6CVN1cHBv
cnRlZAogRjoJZHJpdmVycy9pZGxlL2ludGVsX2lkbGUuYwpAQCAtMzM3Niw3ICszMzc2LDcgQEAg
RjoJZHJpdmVycy9uZXQvaXhnYmV2Zi8KIAogSU5URUwgTVJTVCBQTVUgRFJJVkVSCiBNOglMZW4g
QnJvd24gPGxlbi5icm93bkBpbnRlbC5jb20+Ci1MOglsaW51eC1wbUBsaXN0cy5saW51eC1mb3Vu
ZGF0aW9uLm9yZworTDoJbGludXgtcG1Admdlci5rZXJuZWwub3JnCiBTOglTdXBwb3J0ZWQKIEY6
CWFyY2gveDg2L3BsYXRmb3JtL21yc3QvcG11LioKIApAQCAtNjMwNiw3ICs2MzA2LDcgQEAgU1VT
UEVORCBUTyBSQU0KIE06CUxlbiBCcm93biA8bGVuLmJyb3duQGludGVsLmNvbT4KIE06CVBhdmVs
IE1hY2hlayA8cGF2ZWxAdWN3LmN6PgogTToJIlJhZmFlbCBKLiBXeXNvY2tpIiA8cmp3QHNpc2su
cGw+Ci1MOglsaW51eC1wbUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZworTDoJbGludXgtcG1A
dmdlci5rZXJuZWwub3JnCiBTOglTdXBwb3J0ZWQKIEY6CURvY3VtZW50YXRpb24vcG93ZXIvCiBG
OglhcmNoL3g4Ni9rZXJuZWwvYWNwaS8K
--00151773ea2c7a7cc104aec92c6c--
