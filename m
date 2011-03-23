Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab1CWNsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:48:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64733 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1CWNsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YIIGhfs3phXYEj53t3I6VQxueGVYOtUD1Oyx7dMzqApWd1Q+VBLIieq5/vLijSMXDc
         a9xbm6mxOOngSj5Yv2iiHlCBAksRvpIzCjbmotfsF2ibkJzeq9K7bl/5i949H92tuNkf
         iu1v+gSThdxBTd0+q8OZTvXaxrwR0evYqM16E=
MIME-Version: 1.0
Date: Wed, 23 Mar 2011 14:48:18 +0100
Message-ID: <AANLkTikEYDdL08=DdJ7fLR08r6sWDCHbNoOuGhxGhm7G@mail.gmail.com>
Subject: Support for global block IO throttling?
From: Juerg Haefliger <juergh@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Are there any plans to support global (per cgroup) IO throttling in
the near future? I'm in need of this and would gladly work on it if
nobody else is and if people think this is a useful feature. What I
envision is that one can specify the limits of individual devices in a
group but also specify the overall aggregate limit of the whole group.
I just started looking at the throttling code and haven't quite
figured it out yet so it might take me a bit to get up to speed.

Thanks
...Juerg
