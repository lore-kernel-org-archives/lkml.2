Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0FPFds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:33:48 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53541 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab0FPFdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=E/MRSCojpWND5QqX/PoR6DDvgZnQqfQjkfT1GegunjsIWK2Jmj2Z19oJul3hS+0GSN
         88ms+bHuLTS7r7IEzCy1Ls3USFkPtCul36fdWmVImrJRIWlZlwGa6pYR6SKMeYFrAvcw
         iXMIVde1B+YKRYCtK+k3j8ZCxPjAszuF7txmo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: [PATCH 0/5] Fix set but unused variable warnings 
Date: Tue, 15 Jun 2010 22:33:49 -0700
Message-Id: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Here is another set of patches fixing some warning messages generated 
when building the kernel when using gcc 4.6.0.

This set just focuses in on the variables warnings that are reported
to be unused. Keep in mind there are still lots more warning messages
that I'm seeing, and will try my hardest to see if I can come up with
a fix, but if things become too difficult and so forth then a bug should
be filled etc..
 
And lastly I want to Thank the people who helped me out on the last patch
set I had sent out and so forth.
Please look if you have the time, and let me know.

Thanks!!

Justin P. Mattock
