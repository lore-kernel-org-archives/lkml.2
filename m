Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1EGPYN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 11:24:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44432 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab1EGPYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 11:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PVP6Eip58NVzDGdiocHNPjaeViU9DvRwc1Ji1XVkHexdVJnJ45d8Tc08IuYGVAHwFi
         HqIMM+IqmognPkWMSrTeKPwGTiyPqTtPa1UukIEzZymshdIdyFPqpUpYqLn4+oeQk7rh
         YdJCUt7mnXZWwEC+TNX5jNkA3a/hT+EYfHuz8=
MIME-Version: 1.0
In-Reply-To: <BANLkTikF5YL8tJ_f5510yy1Ywm69rOUK2A@mail.gmail.com>
References: <BANLkTi=8U3=E0=j8MJ-r70O_aO8Pxvv9Nw@mail.gmail.com>
	<BANLkTi=F8u7oZM+=W+5vzmvf1b0YiN0fQg@mail.gmail.com>
	<20110420080535.3edd11ac@pluto.restena.lu>
	<20110420105631.70695dfa@lxorguk.ukuu.org.uk>
	<BANLkTikF5YL8tJ_f5510yy1Ywm69rOUK2A@mail.gmail.com>
Date: Sat, 7 May 2011 18:24:09 +0300
Message-ID: <BANLkTi=x76zkTpZxaHUnSUeP+_O0SsK0Zw@mail.gmail.com>
Subject: Re: [2.6.39-rc2, framebuffer] use after free oops
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Daniel J Blueman.

Did you test https://lkml.org/lkml/2011/5/5/208 ? And it works for you ?
Then please reply with your error and an Tested-by.

And CC: "Dave Airlie" <airlied@redhat.com>
