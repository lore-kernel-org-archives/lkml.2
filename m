Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1BDRLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:11:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47098 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1BDRLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=u90hKkGb9nkBHS1wfl9kGEevdDOXpJjOXo/ziCPafqovM1Gb534SdisO3GOWjQ5hR8
         7+ioPibabjFHUZAsrEEHfbfuSBi1BAF9EC/wZBHsI53Ma+IkSIwtjwbqE7hBSJOFvZ2v
         A9dVt+ffNvq4PEHMbVw07XmGvPnChh40F34RQ=
MIME-Version: 1.0
Date: Fri, 4 Feb 2011 12:11:13 -0500
Message-ID: <AANLkTinbnrAMMKVZSBQChtZjUyw6Yk1otp8xmqJNvWm3@mail.gmail.com>
Subject: Thread Affinity structure
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

    I have doubt regarding how the thread affinity (to processor) is
defined in a process (task). If there is only single thread in a
process, then when process calls itself on binding to a core, will let
run on that core forever. But, what if there are multiple threads, in
a process (task). If the main thread calls set affinity to a core, is
it going to get inherited to all other threads, or just the calling
thread in a task. What happens when forked a process with threads that
has affinity to a core. Please can anyone point me to the literature
on this. Thanks in advance.

-- 
Regards,
Sri.
