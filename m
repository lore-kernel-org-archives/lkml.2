Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0JZHxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 03:53:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44951 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab0JZHw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 03:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MjpAwH1+tj7Ux8Tm87E+RB0uaXzpa8vkhdjsthqCm/+rHSLcbVDZ793nnLxhkWc5T2
         2bBg8t4YpMeu1F2S+zg90IEOoalD03SnpNV9h8W8UE/p1l0g1JxuG/50UoxXJ+qts3dM
         O9UyDGZARTURDAV6PV0wZzM6mGd5yRavxirqo=
MIME-Version: 1.0
Date: Tue, 26 Oct 2010 11:52:44 +0400
Message-ID: <AANLkTimzEDtfUKajFPgGOhifPhyRQboZbKNbypBaKpKO@mail.gmail.com>
Subject: Tickles scheduler
From: Dragoslav Zaric <zaricdragoslav@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did anybody test and compare work of ticking and tickles scheduler ?

Currently I think it is implemented as ticking scheduler with
hard-coded frequency (usually 100 Hz).

Personally I think that tickles scheduler is much better solution, but
maybe I am over-view something and
maybe there are side effects when implementation starts ? Instead of
tick, we can wait for events to happen
(for example IRQ, add or remove process from list), and when periodic
actions are needed, we can time
schedule them dynamically based on system load.

Can somebody give me some insight in this issue if he has any
experience with this ?

Is it at all possible to implement kernel without ticking, spin system
by events and periods ?
Maybe ticking is still best solution to have fast responding system ?

Kind regards

-- 
Dragoslav Zaric

Professional Programmer
MSc Astrophysics
