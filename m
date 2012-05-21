Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2EUQ2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:28:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43283 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab2EUQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:28:34 -0400
MIME-Version: 1.0
Reply-To: ivo.welch@gmail.com
From: ivo welch <ivo.welch@anderson.ucla.edu>
Date: Mon, 21 May 2012 09:28:13 -0700
X-Google-Sender-Auth: 0ho6-Y1dtPj_JGBu2d8yI-bgCWE
Message-ID: <CAPr7RtUBDn01qDkxvcLO8ZckAtTmCCJk7hCjwH4_XziwXtAS6Q@mail.gmail.com>
Subject: the easy way to sandbox?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggestion:  introduce a system call that eliminates access to all
real file systems for the current process.  the only permissible
interaction would be stdin, stdout, and stderr.

this would make it very simple to write a sandboxed safe fcgi script.
the script could load all the dynamic libraries and data it wants, and
then call this no-more-filesystem-access feature (preferably allowable
without root privileges).  thereafter, even if a hacker takes control
of the script, not much permanent damage can happen.

right now, it is much more complex to accomplish this---which is why
sandboxing cgi scripts is not used too often.

sincerely,

/iaw

----
Ivo Welch (ivo.welch@gmail.com)
