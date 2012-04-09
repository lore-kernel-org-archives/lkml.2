Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab2DIG2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 02:28:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54371 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2DIG2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 02:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120409010816.36244f17@xenia.leun.net>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<4F7A923D.5000002@candelatech.com>
	<CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
	<4F7A9D5C.8040402@silka.with-linux.com>
	<CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
	<4F7AAAD9.2040307@silka.with-linux.com>
	<CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
	<20120403200306.0afbb48b@xenia.leun.net>
	<CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
	<CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
	<20120404235104.682cfad3@xenia.leun.net>
	<4F7DE3A4.1040705@candelatech.com>
	<CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
	<4F7F52BD.7060906@candelatech.com>
	<20120409010816.36244f17@xenia.leun.net>
Date: Mon, 9 Apr 2012 11:58:06 +0530
Message-ID: <CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com>
Subject: Re: 3.4-rc ath9k regression (Re: [ath9k-devel] 3.3.1 ath9k regression)
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Michael Leun <lkml20120218@newton.leun.net>
Cc: Ben Greear <greearb@candelatech.com>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec51a8e52f7fc7a04bd391b25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec51a8e52f7fc7a04bd391b25
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Apr 9, 2012 at 4:38 AM, Michael Leun
<lkml20120218@newton.leun.net> wrote:
> After an suspend to disk / resume cycle (in kernel suspend to disk,
> openSuSE) with 3.4-rc2 my ath9k wireless does not ping
> anymore.
>
> Output of iwconfig wlan0 looks just as usual (associated to AP).
>
> iwconfig wlan0 essid <myssid> fixes this (causes an
> deauthenticate/authenticate with AP) - then connectivity is there again.
>
> Guess what: "Of course" does not happen when reverting
> c1afdaff90538ef085b756454f12b29575411214 ath9k: fix going to full-sleep
> on PS idle.
>
> So, in my opinion it should be seriously considered to revert that patch
> until it is fully understood what is going on and why.

please try with the attached patch to see if it helps.

>
> It may look theoretically correct (I've no knowledge that would enable
> me assess that), but it seems to have caused 3 more or less different
> problems to various people.
>
> --
> MfG,
>
> Michael Leun
>



-- 
thanks,
shafi

--bcaec51a8e52f7fc7a04bd391b25
Content-Type: text/x-diff; charset=US-ASCII; name="test.patch"
Content-Disposition: attachment; filename="test.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h0t52e2i0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9tYWluLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvbWFpbi5jCmluZGV4IDIxNWViMjUuLjkyZGEyMGEg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9tYWluLmMKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL21haW4uYwpAQCAtMTE4LDE0ICsxMTgsMTIg
QEAgdm9pZCBhdGg5a19wc19yZXN0b3JlKHN0cnVjdCBhdGhfc29mdGMgKnNjKQogCWlmICgtLXNj
LT5wc191c2Vjb3VudCAhPSAwKQogCQlnb3RvIHVubG9jazsKIAotCWlmIChzYy0+cHNfZmxhZ3Mg
JiBQU19XQUlUX0ZPUl9UWF9BQ0spCi0JCWdvdG8gdW5sb2NrOwotCiAJaWYgKHNjLT5wc19pZGxl
KQogCQltb2RlID0gQVRIOUtfUE1fRlVMTF9TTEVFUDsKIAllbHNlIGlmIChzYy0+cHNfZW5hYmxl
ZCAmJgogCQkgIShzYy0+cHNfZmxhZ3MgJiAoUFNfV0FJVF9GT1JfQkVBQ09OIHwKIAkJCSAgICAg
IFBTX1dBSVRfRk9SX0NBQiB8CisJCQkgICAgICBQU19XQUlUX0ZPUl9UWF9BQ0sgfAogCQkJICAg
ICAgUFNfV0FJVF9GT1JfUFNQT0xMX0RBVEEpKSkKIAkJbW9kZSA9IEFUSDlLX1BNX05FVFdPUktf
U0xFRVA7CiAJZWxzZQo=
--bcaec51a8e52f7fc7a04bd391b25--
