Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab1FWNOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:14:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58766 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab1FWNOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=Jh+QeMJtVsYXRXugKWZ7QQtt0Ipd9YSaW1q2iNUhn/LQqNtrugOliTXbODyNf1a7ew
         P9kcGcnv5f5XWiFk34Hxkg/b5+N6wVsox3t+VAxqDW8RNSVNaDPdRETnIW9mTc7oCP3M
         xXPy16tr4DCL5oJIhRaOcqTVs5tXk2bpI3ZD8=
MIME-Version: 1.0
From: yuyichao-mit <yuyichao@mit.edu>
Date: Thu, 23 Jun 2011 09:14:18 -0400
X-Google-Sender-Auth: skFeQ3fIyMxZFDVq1roF4fvj-14
Message-ID: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
Subject: extra slash in current path
To: linux-kernel@vger.kernel.org, linux-c-programming@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is like this:

$ cd /
$ pwd
/

$ cd /
$ pwd
//

$ cd ///
$ pwd
/

Why can there be a extra slash (and exactly one) in current path? Is
this designed on purpose?
This is not really a big deal but I think it can confuse some program.

Thanks.

Yichao
