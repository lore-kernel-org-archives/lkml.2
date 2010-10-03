Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0JCOId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 10:08:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46349 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0JCOIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 10:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ftoAJPR3/FkE++LlUQEExpjd9NlCNsjhnkJ9aa25SsMg9KD+XPcLpqXVvBtgLiCfAi
         q4zOlT+HrY7iEEt+wbyOtJ110dcgETw7MGzUInWSF9EovSbCcyClanJC+wiV+HOkxCrG
         7lRYRBFnNa8NXro6o1eSjl9uEcF3GY+UeAdn0=
MIME-Version: 1.0
Date: Sun, 3 Oct 2010 10:08:31 -0400
Message-ID: <AANLkTi=SPrzdX6uWSKtREFhnzqtLOWedEyMU-RrLHM62@mail.gmail.com>
Subject: a doubt on scheduler
From: prajul phalgunan <prajulphalgunan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i  am a beginner to linux kernel and trying to learn especially how
linux schedules processes
i have  read some books on linux kernel but left with the some doubts.

1.how does the scheduler that it schedules all task within the
sysctl_sched_latency
2.when a process wakes up what actually is done in the place_entity function
3.when a process wakes up why the vruntime is adjusted by subtracting
from sched_latency,cant it lead to processes in the run queue with
large difference in the vruntime value

Expecting some one to respond...please..
thanks in advance..
