Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab2AYXbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:31:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43295 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2AYXbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:31:45 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1201251902590.12477@skynet.skynet.ie>
References: <alpine.DEB.2.00.1201251902590.12477@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Jan 2012 15:31:24 -0800
X-Google-Sender-Auth: -YGQ0YDmgYTHp2Yg1EYlLXIwKhg
Message-ID: <CA+55aFxTAHTXRmnK9AeJm525u28SGRxCRMAvY8rJcNuwkHANtg@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Dave Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 11:05 AM, Dave Airlie <airlied@linux.ie> wrote:
>
> bunch of regression fixes since TTM rework and radeon initialisation,
> modesetting fixes for Alex to fix some black screens on kms start type
> issues, and two radeon ACPI fixes that make some laptops no oops on
> startup.

Does that include for the nvidia (?) suspend/resume issue? You were
cc'd on it (but the subject may have made you ignore it - it was part
of a thread about wireless network suspend issues: "bcma/brcmsmac
suspend/resume cleanups and fixes"):

  No trivial bisect. I wish I had a faster build machine, but alas. I
  suspected some issue in DRM and the bisect took me into drm-core-next
  branch. I ended up at the following commit:

  dc97b3409a790d2a21aac6e5cdb99558b5944119 is the first bad commit
  commit dc97b3409a790d2a21aac6e5cdb99558b5944119
  Author: Jerome Glisse <jglisse@redhat.com>
  Date:   Fri Nov 18 11:47:03 2011 -0500

Hmm?

                     Linus
