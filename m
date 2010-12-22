Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab0LVDys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 22:54:48 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54471 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0LVDyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 22:54:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=g1mur8tNavX+ZKnEnwUmdmaLqKBXeqCOM8iWicq1Ulap9V+2GUPuwNmXkdbkr7T0XM
         pCcDedBmvg24WeHxOi9wGBiDMKoXtcXIJqTre6N0JN9GYqjbLAWxiSwJ/MRQ0En9hNMT
         9WrKXgDE7j53WTPkJVYY6ZROXSDAHMs/yDps8=
MIME-Version: 1.0
In-Reply-To: <4D116E40.1060204@earthlink.net>
References: <alpine.DEB.2.00.1012212339090.30885@skynet.skynet.ie>
	<4D116E40.1060204@earthlink.net>
Date: Wed, 22 Dec 2010 13:54:45 +1000
Message-ID: <AANLkTimgqo3mc3xgysd2PPf+pbxO08LXkFf1H=Y2uAry@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: sclark46@earthlink.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I am new to git and can't figure out how to get these changes.
>
> I have done a git clone of
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> What next?

the easiest way:
You can git pull my tree into that

git pull git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
drm-fixes

though you should really setup remotes

git remote add airlied
git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
git fetch airlied
git branch drm-fixes
git pull . remotes/airlied/drm-fixes

Dave.
