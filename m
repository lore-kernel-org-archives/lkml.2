Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161672Ab2CPPWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:22:53 -0400
Received: from smtp12.mail.ru ([94.100.176.89]:57556 "EHLO smtp12.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161465Ab2CPPWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:22:51 -0400
From: "Igor Sobinov" <sluge@mail.ru>
Subject: Question about disk I/O erros statistic
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
	charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Mar 2012 19:22:49 +0400
X-Mailer: Koma-Mail
Message-Id: <E1S8YzS-0008Rr-2J.sluge-mail-ru@smtp12.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
I have a question about checking disk I/O errors on linux:

So, I used a solaris OS from oracle for a last period of time and found that it has a interesting option of iostat: -e and -E keys that
shows HW and SW errors of disk usage, like this:

from solaris man:

-e Display device error summary statistics. The
total errors, hard errors, soft errors, and
transport errors are displayed.

-E Display all device error statistics.



# iostat -e
---- errors ---
device s/w h/w trn tot
dad1 0 0 0 0
dad2 0 0 0 0
sd1 0 0 1 1
nfs1 0 0 0 0
nfs6 0 0 0 0

# iostat -E

dad1 Soft Errors: 0 Hard Errors: 0 Transport Errors: 0
Model: XXXXXXXX Revision: 8.01 Serial No: XXXXXXXX
Size: XXX.00GB <XXX bytes>
Media Error: 0 Device Not Ready: 0 No Device: 0 Recoverable: 0
Illegal Request: 0

sd1 Soft Errors: 0 Hard Errors: 0 Transport Errors: 1
Vendor: XXXXX Product: CDW/DVD XXXX Revision: XXXX Serial No:XXXX
Size: 0.00GB <0 bytes>
Media Error: 0 Device Not Ready: 0 No Device: 0 Recoverable: 0
Illegal Request: 1 Predictive Failure Analysis: 0


So, this is the great info that is very useful for many purposes, but it is not available on linux(((( Does anybody knows why?
Is any existing solution on linux that supports this features?


Regards, Igor

