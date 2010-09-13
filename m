Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0IMT67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:58:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54942 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab0IMT65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:58:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Ix6pHt2P2LTLA0pVlo1bAzjiTI4uwN4Bm8I0AP49sZ0OvxhBxSOI7XqNXZLItsgPkG
         48JCZQk5aRp/QfbK4HYI/oX/UmjgX1zLvyfWcP4hQdeUr9VfwyeRPtQgv9Mhs3j9kVBt
         mYTs9awU5B1Gh4driyZTk9tqAI8QAJeWcuRJE=
MIME-Version: 1.0
Date: Tue, 14 Sep 2010 04:58:56 +0900
Message-ID: <AANLkTikHM+o_FCgnVzGhs8UtQ_geXFzKNQpGSZiEN7sx@mail.gmail.com>
Subject: OMAP3 DSP MMU fault + off mode issue
From: venki kaps <venkiece2005@gmail.com>
To: omar.ramirez@ti.com, h-kanigeri2@ti.com, ameya.palande@nokia.com,
        fernando.lugo@ti.com, x0hebbar@ti.com, ernesto@ti.com,
        felipe.contreras@gmail.com, s-anna@ti.com, grgupta@ti.com,
        ivan.gomez@ti.com, ext-andriy.shevchenko@nokia.com, x0095078@ti.com,
        deepak.chitriki@ti.com, nm@ti.com, ext-phil.2.carmody@nokia.com,
        ohad@wizery.com, greg@kroahDONOTSPAM.com, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I have been facing an issue with OMAP3 PM with DSP MMU Fault (Kernel 2.6.32).

The issue is describing as below mentioned way,
        1). The Device is getting DSP MMU Fault when playing MP4 video clip.

The system is not hitting off mode in the below scenario,
        2). System boot ->play mp4 clip ->DSP MMU Fault -> allow off
mode -----------> Never hits off mode

But surprisingly the system is hitting off mode in the below scenario,
       3). System boot ->allow off mode ->play mp4 clip ->DSP MMU
Fault -> allow off mode -----------> perfectly works


 - Could you please describe the root cause about the above issues 1 & 2?
 - How could solve the above issues?

Best Regards,
Venkii
