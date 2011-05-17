Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1EQOj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:39:28 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44136 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab1EQOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=S6idVvMJ4Lv1ezCG0SNZmKOqk4RpKZUFFBTnYhxgTjfTOz8lfwcWKNrGOfC8vBoFYk
         bcRXb+mm1ATdS7GzCT8o5Kmz37kg2XO93UWNtAvY+cG86IJpyxqqYuX1xdaUScs83C/p
         orqlAAazv9Sa10cSEePC0uWZpcStzuPX9NX/A=
MIME-Version: 1.0
Date: Tue, 17 May 2011 09:39:23 -0500
Message-ID: <BANLkTikn3OawHFO8y20sLuK_4LxOw7nQBg@mail.gmail.com>
Subject: Reconsider including phc-linux patch to control voltages
From: Arthur Machlas <arthur.machlas@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, please cc me on any replies.

Five years ago a request was made[1] to include some patches from the
phc-linux project. This request was rejected for reasons of stability,
wasting dev time chasing bugs, and general discomfort. Mildly
supportive suggestions were made to make it either a separate driver
(it patches acpi-cpufreq) or call some 'tainted' flags.

It is currently included in the zen kernel, and now supports out of
tree building making it somewhat unecessary to include, however, the
dev's seem unable to keep up with newer kernels and releases are
becoming infrequent. Users now seem to be modifying the patch to make
sure it cleanly applies to newer kernels. Gentoo seems to be doing
this at the distro level [2].

Just wondering if any circumstances have changed that would merit
reconsidering the decision to not include the patches.

Many thanks,
Arthur

[1] http://lkml.org/lkml/2007/9/2/119
[2] http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/sys-power/phc-intel/files/phc-intel-0.3.2.12.1-2.6.38.patch?view=markup
