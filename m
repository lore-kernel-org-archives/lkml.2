Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0G1BnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 21:43:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52417 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab0G1BnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 21:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AUs2gJ5WJ0jcT3MxtxGsD0sQwTXs1e+qATxcErYNKF1hpQP8ZxZ4xYHquq7j/RlnaB
         bCg7gA5In6x0KcQROmwB+ellVe4jvLfirEsukPob3H/Yv6qF8pXYD6nYsXzVliB6GG4n
         7RUN4+NcWzlLc1pwlY7dnnhqcWqL4CRQLQ7S0=
MIME-Version: 1.0
Date: Tue, 27 Jul 2010 19:43:17 -0600
Message-ID: <AANLkTi=Ojnj62WPUL12-DQdpY4=aVmWLiM+48tmcf+xR@mail.gmail.com>
Subject: [ANNOUNCE] Open CWorthy Libraries 07-27-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CURRENT
http://cworthylinux.googlecode.com/files/cworthy-07-27-2010.tar.gz

REPOSITORIES
http://code.google.com/p/cworthylinux/
http://sourceforge.net/projects/opencworthy/

FIXES
- fix pthread_mutex_lock deadlock in refresh_screen() wen called from
pthread_cancel
- add support for shaded fields based on field input
- add cwgen packet generator CWorthy sample application.
- add cwgen.ko support for linux kernel 2.6.34.1
- add clear_portal_storage function for clearing portal storage
without blanking the screen
- add MSDOS and DRDOS build defines and includes
- add Windows build defines and includes
- add pthread_setcancelstate() to sample program to prevent deadlocks during
  calls to pthread_cancel.  You need to set the cancel state to disable when
  pthread_mutex_lock is called and a process is holding a lock during cancel
  operations
- add saved flag to menu_frame to check if we have previously saved a screen
  area before calling restore_menu
- add fixes to input_portal_fields to redraw the portal after F10 submit

TODO
- write another cworthy kernel app and think about more
- write cworthy application version of net-tools for network monitoring
- write cworthy application for monitoring disk and lan throughput totals
