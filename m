Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0GANtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:49:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36997 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0GANtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=RckXSrqUWO54v2PIsrpepHRW+jaBfsddh1otkJnWnwqncfMW3UATgFeEZ2TZvyn2MU
         0iWxLKdSg2csCHnCKqBvn1cRKZh4Ef30Twm3myaY3HJq1bm8zQjllNE+KLgIywYkR0n7
         oFmZypC9gpX6uI23GATZLJ/RE4GS+g+QKGxH0=
MIME-Version: 1.0
Date: Thu, 1 Jul 2010 16:49:30 +0300
Message-ID: <AANLkTinSHgGfnT8ne7UZW01q3IA2qMNhAeNxMLqvwE98@mail.gmail.com>
Subject: suspend/resume and kernel timers
From: Budhee Jamaich <budheej@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What happens with kernel timers when system enters suspend mode ?

Are they suspended too ?

When a driver's suspend handler is called, can previous timers the
driver setup suddenly be triggered ?

Thank You
Budhee
