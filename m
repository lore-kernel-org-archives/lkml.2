Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab0HEVyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:54:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65412 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab0HEVyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=VUdqiE21+v2tRyftbmdSOD2NAVL1jHyB4JMZy+XiqR4THxbtE3CLq20+2ESGzDd2Ek
         vsodiBwOexDD+rnGUJKzPMCbMjiL8Gi6ZWT0JOiyIxREOiyuHKh5/CUYm06Wxo8xfadQ
         ZU4nLKn6gBETvbalYX4fpqHv3gzIaFlhwqRVo=
MIME-Version: 1.0
Date: Thu, 5 Aug 2010 23:54:09 +0200
X-Google-Sender-Auth: iSr_8U9RYgJkY4Bx6SuGu-4yGeo
Message-ID: <AANLkTin5gz-NBGYrmdOQ4F4s-fbETq642JVsHEEJY4HD@mail.gmail.com>
Subject: Best way to send several patches
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I'm reading on the kernelnewbies wiki about janitor work needing be to done.
I have been cleaning up some stuff, and have alot of patches (I have
split my changed into smaller patches).

The question is, should I just send them all to this mailinglist
(Section 3 of Documentation/SubmittingPatches - the one with the patch
bomb - suggest that this is a bad idea), or how should I do it? (I
have only submitted a single patch before, so I didn't have to worry
about that back then).

I have been thinking about sending a pull request, but since I've only
done one patch up until now, I find it unlikely to be trusted enough
to get a pull request through (correct me if I'm wrong).

Best regards,
Bjarke
