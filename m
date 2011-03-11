Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1CKBI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:08:56 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:60851 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1CKBIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:08:55 -0500
Message-ID: <0f66fbcc9c86ced2cfe625395de31835.squirrel@webmail.greenhost.nl>
In-Reply-To: <a43587d716af46c642fe30e779204ca0.squirrel@www.ffwll.ch>
References: <af572f9c6c75d54f1f81e51f508358dd.squirrel@webmail.greenhost.nl>
    <1298395549-4064-1-git-send-email-daniel.vetter@ffwll.ch>
    <ed85db84d2d5ea460898d78e1179c6ca.squirrel@webmail.greenhost.nl>
    <25dfe766fbe767e249ef95d1fda0094c.squirrel@www.ffwll.ch>
    <0378a20bb9cfafee46c89461fa2dd4d6.squirrel@webmail.greenhost.nl>
    <8b77a7a0de898635c8b25e7612907deb.squirrel@www.ffwll.ch>
    <2e9ca0040729649ed989a16a07bb2c49.squirrel@webmail.greenhost.nl>
    <a43587d716af46c642fe30e779204ca0.squirrel@www.ffwll.ch>
Date: Fri, 11 Mar 2011 02:08:46 +0100 (CET)
Subject: Re: [PATCH] drm/i915: fix corruptions on i8xx due to relaxed      
     fencing
From: "Indan Zupancic" <indan@nul.nu>
To: "Daniel Vetter" <daniel@ffwll.ch>
Cc: "Daniel Vetter" <daniel@ffwll.ch>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 74b82c602e180a6a7275945acf229479
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, March 10, 2011 14:31, Daniel Vetter wrote:
> Am Do, 10.03.2011, 11:36 schrieb Indan Zupancic:
>> Which versions fix this, just for reference?
>
> git master branch of libdrm and xf86-video-intel newer than 2011-02-22.

Thank you. If there will be no new releases of those packages within
a couple weeks it might be better to temporarily add those checks back
for gen 2 only, I think. Otherwise there will be a period where people
who update regularly will have screen corruption, with no easy way of
fixing it. I think this would avoid a few unnecessary bugreports. The
check can be removed in 2.6.39-rc1, if you want I'll remind you about
it too.

Greetings,

Indan


